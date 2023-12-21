# frozen_string_literal: true

require 'sendgrid-ruby'
require 'json'

class MailerService
  include SendGrid

  def self.mail(to, substitutions, template_id, attachments = nil)
    mail = setup_mail(template_id)
    add_personalization(mail, to, substitutions)
    add_attachments(mail, attachments) if attachments_present?(attachments)
    send_mail(mail)
  end

  def self.setup_mail(template_id)
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: ENV.fetch('SENDGRID_MAIL_SENDER'))
    mail.template_id = template_id
    mail
  end

  def self.add_personalization(mail, to, substitutions)
    personalization = Personalization.new
    personalization.add_to(Email.new(email: to))
    personalization.add_dynamic_template_data(substitutions)
    mail.add_personalization(personalization)
  end

  def self.attachments_present?(attachments)
    attachments.present? && attachments.is_a?(Array) && attachments.size.positive?
  end

  def self.add_attachments(mail, attachments)
    attachments.each do |attachment_input|
      attachment = Attachment.new
      attachment.content = Base64.strict_encode64(attachment_input[:data])
      attachment.type = attachment_input[:type]
      attachment.filename = attachment_input[:name]
      attachment.disposition = 'attachment'
      attachment.content_id = attachment_input[:content_id]
      mail.add_attachment(attachment)
    end
  end

  def self.send_mail(mail)
    sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
    begin
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      response.status_code
    rescue StandardError => e
      logger.error(e&.message)
      Sentry.capture_exception(e)
    end
  end

  private_class_method :setup_mail, :add_personalization, :attachments_present?, :add_attachments, :send_mail
end
