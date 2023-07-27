# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset_email(user)
    @user = user
    @reset_password_url = user.reset_password_token
    mail(to: @user.email, subject: I18n.t('mailer.user.password_reset'))
  end
end
