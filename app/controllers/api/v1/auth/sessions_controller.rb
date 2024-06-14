# frozen_string_literal: true

class Api::V1::Auth::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: :ok,
      message: I18n.t('auth.sessions.logged_in_successfully'),
      data: { user: UserSerializer.new(current_user) }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split.last, ENV.fetch('DEVISE_JWT_SECRET')).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: {
        status: :ok,
        message: I18n.t('auth.sessions.logged_out_successfully')
      }, status: :ok
    else
      render json: {
        status: :unauthorized,
        message: I18n.t('auth.sessions.no_active_session')
      }, status: :unauthorized
    end
  end
end
