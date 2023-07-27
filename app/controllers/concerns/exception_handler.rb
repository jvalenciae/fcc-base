# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  include ErrorResponses

  included do
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
    rescue_from(CanCan::AccessDenied) { |err| handle_access_denied_error(err) }
    rescue_from(JWT::ExpiredSignature) { |err| handle_jwt_expired_signature_error(err) }
    rescue_from(JWT::VerificationError) { |err| handle_jwt_verification_error(err) }
  end
end
