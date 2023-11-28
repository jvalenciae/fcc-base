# frozen_string_literal: true

module TypeformWebhookVerificator
  extend ActiveSupport::Concern

  included do
    before_action :verify_typeform_webhook_authenticity
  end

  private

  def verify_typeform_webhook_authenticity
    secret_key = ENV.fetch('TYPEFORM_WEBHOOK_SECRET')
    request_data = request.body.read
    received_signature = request.env['HTTP_TYPEFORM_SIGNATURE']

    render json: { message: 'No Secret' }, status: :unauthorized and return if received_signature.nil?

    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_key, request_data)
    expected_signature = "sha256=#{Base64.strict_encode64(hash)}"

    return if ActiveSupport::SecurityUtils.secure_compare(received_signature, expected_signature)

    render json: { message: 'Wrong Secret' }, status: :unauthorized and return
  end
end
