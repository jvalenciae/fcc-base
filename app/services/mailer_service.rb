# frozen_string_literal: true

require 'sendgrid-ruby'

class MailerService
  # rubocop:disable Metrics/MethodLength
  def self.mail(to, substitutions, template_id)
    data = {
      personalizations: [
        {
          to: [
            {
              email: to
            }
          ],
          dynamic_template_data: substitutions
        }
      ],
      from: {
        email: ENV.fetch('SENDGRID_MAIL_SENDER')
      },
      template_id: template_id
    }.to_json
    sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
    begin
      response = sg.client.mail._('send').post(request_body: data)
      response.status_code
    # rubocop:disable Lint/RescueException
    rescue Exception => e
      logger.error(e&.message)
      Sentry.capture_exception(e)
    end
    # rubocop:enable Lint/RescueException
  end
  # rubocop:enable Metrics/MethodLength
end
