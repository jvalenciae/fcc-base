# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset(user)
    to = user.email
    hostname = ENV.fetch('FRONTEND_HOSTNAME')
    token = user.reset_password_token
    substitutions = {
      subject: I18n.t('mailer.user.password_reset'),
      password_reset_url: "#{hostname}/restablecer-contrasena?token=#{token}"
    }
    template_id = 'd-f2fc5645567746519dc51b38299625fb'
    MailerService.mail(to, substitutions, template_id)
  end

  def invitation(user, current_user)
    to = user.email
    hostname = ENV.fetch('FRONTEND_HOSTNAME')
    first_name = current_user.first_name
    last_name = current_user.last_name
    token = user.reset_password_token
    substitutions = {
      subject: I18n.t('mailer.user.invitation'),
      first_name: first_name,
      last_name: last_name,
      password_reset_url: "#{hostname}/restablecer-contrasena?token=#{token}&invitedBy=#{first_name}+#{last_name}"
    }
    template_id = 'd-3e3e4e1be0624523b4ed178ccafd5d8e'
    MailerService.mail(to, substitutions, template_id)
  end
end
