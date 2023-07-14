# frozen_string_literal: true

class ApiController < ApplicationController
  rescue_from(ArgumentError) { |err| handle_argument_error(err) }
  rescue_from(ActiveRecord::RecordNotFound) { |err| handle_active_record_not_found_error(err) }
  rescue_from(ActiveRecord::RecordInvalid) { |err| render_record_not_valid_error(err) }
  rescue_from(ActiveRecord::RecordNotUnique) { |err| handle_active_record_not_unique_error(err) }
  rescue_from(ActiveRecord::StatementInvalid) { |err| handle_active_record_statement_invalid_error(err) }
  rescue_from(ActionController::ParameterMissing) do |err|
    handle_action_controller_parameter_missing_error(err)
  end
  rescue_from(ActionController::RoutingError) { |err| handle_action_controller_routing_error(err) }
  rescue_from(ActiveModel::ForbiddenAttributesError) do |err|
    handle_active_model_forbidden_attributes_error(err)
  end

  def render_response(data: nil, status_code: :ok, serializer: nil, meta: nil, serializer_params: {})
    if status_code == :no_content
      render_no_content
      return
    end

    if serializer.present?
      if data.respond_to?(:each)
        render_multiple_response(data, status_code, serializer, meta, serializer_params)
      else
        render_single_response(data, status_code, serializer, meta, serializer_params)
      end
    else
      render_raw_response(data, status_code, meta)
    end
  end

  private

  def render_no_content
    head :no_content
  end

  def render_raw_response(data, status_code, meta)
    render json: {
      status: status_code,
      data: data,
      meta: meta
    }, status: status_code
  end

  def render_multiple_response(data, status_code, serializer, meta, serializer_params)
    render json: {
      status: status_code,
      data: ActiveModel::Serializer::CollectionSerializer.new(
        data, {
          serializer: serializer,
          serializer_params: serializer_params
        }
      ),
      meta: meta
    }, status: status_code
  end

  def render_single_response(data, status_code, serializer, meta, serializer_params)
    render json: {
      status: status_code,
      data: serializer.new(data, { serializer_params: serializer_params }),
      meta: meta
    }, status: status_code
  end

  def render_error_response(err, message = 'An error has occurred', status_code = :bad_request, type = 'error',
                            errors = [])
    logger.error(message)
    Sentry.capture_exception(err)

    render json: {
      message: message,
      status: status_code,
      type: type,
      errors: errors
    }, status: status_code
  end

  def handle_argument_error(err)
    render_error_response(err, err&.message, :bad_request, type: 'argument_error')
  end

  def handle_active_record_not_found_error(err)
    render_error_response(err, err&.message, :not_found, type: 'not_found_error')
  end

  def handle_active_record_statement_invalid_error(_err)
    render_error_response(err, 'Invalid statement in field', :unprocessable_entity, 'invalid_statement_error')
  end

  def handle_active_model_forbidden_attributes_error(_err)
    render_error_response(err, 'Forbidden attributes in record', :unprocessable_entity, 'forbidden_attribute_error')
  end

  def handle_action_controller_parameter_missing_error(err)
    render_error_response(err, "Missing parameter #{err&.param}", :bad_request, 'parameter_missing_error')
  end

  def handle_action_controller_routing_error(err)
    render_error_response(err, err&.message, :bad_request, 'routing_error')
  end

  def handle_active_record_not_unique_error(_err)
    render_error_response(err, 'A record already exists', :bad_request, 'not_unique_error')
  end

  def render_record_not_valid_error(err)
    render_error_response(err, err&.message, :unprocessable_entity, 'invalid_error', err.record&.errors&.messages)
  end

  def handle_unauthorized_error(err = 'User is not authorized')
    render_error_response(err, err, :unauthorized, 'unauthorized_error')
  end

  def handle_forbidden_error(err = 'Forbidden action')
    render_error_response(err, err, :forbidden, 'forbidden_error')
  end
end
