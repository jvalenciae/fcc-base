# frozen_string_literal: true

module ErrorResponses
  private

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

  def handle_active_record_statement_invalid_error(err)
    render_error_response(err, 'Invalid statement in field', :unprocessable_entity, 'invalid_statement_error')
  end

  def handle_active_model_forbidden_attributes_error(err)
    render_error_response(err, 'Forbidden attributes in record', :unprocessable_entity, 'forbidden_attribute_error')
  end

  def handle_action_controller_parameter_missing_error(err)
    render_error_response(err, "Missing parameter #{err&.param}", :bad_request, 'parameter_missing_error')
  end

  def handle_action_controller_routing_error(err)
    render_error_response(err, err&.message, :bad_request, 'routing_error')
  end

  def handle_active_record_not_unique_error(err)
    render_error_response(err, 'A record already exists', :bad_request, 'not_unique_error')
  end

  def render_record_not_valid_error(err)
    render_error_response(err, err&.message, :unprocessable_entity, 'invalid_error', err.record&.errors&.messages)
  end

  def handle_unauthorized_error(err = 'User is not authorized')
    render_error_response(err, err&.message, :unauthorized, 'unauthorized_error')
  end

  def handle_forbidden_error(err = 'Forbidden action')
    render_error_response(err, err&.message, :forbidden, 'forbidden_error')
  end

  def handle_access_denied_error(err = 'Forbidden action')
    render_error_response(err, err&.message, :unauthorized, 'unauthorized_error')
  end

  def handle_jwt_expired_signature_error(err = 'Signature has expired')
    render_error_response(err, err&.message, :unauthorized, 'unauthorized_error')
  end

  def handle_jwt_verification_error(err = 'JWT token is invalid or expired')
    render_error_response(err, err&.message, :unauthorized, 'unauthorized_error')
  end
end
