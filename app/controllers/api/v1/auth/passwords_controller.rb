# frozen_string_literal: true

module Api
  module V1
    module Auth
      class PasswordsController < ApiController
        skip_before_action :authenticate_user!

        def create
          user = User.find_by!(email: params[:email])

          user.generate_reset_password_token
          UserMailer.password_reset_email(user).deliver_now
          render json: { token: user.reset_password_token }
        end

        def update
          user = User.find_by!(reset_password_token: params[:token])
          user.validate_reset_password_token
          raise ActiveRecord::RecordInvalid.new(user) unless user.errors.empty?
          return unless user.update!(password: params[:password], password_confirmation: params[:password_confirmation])

          render json: {
            status: :ok,
            message: 'Password changed successfully'
          }, status: :ok
        end
      end
    end
  end
end
