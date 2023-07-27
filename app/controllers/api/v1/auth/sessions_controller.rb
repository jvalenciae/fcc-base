# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        include ExceptionHandler

        respond_to :json

        private

        def respond_with(current_user, _opts = {})
          render json: {
            status: :ok,
            message: 'Logged in successfully.',
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
              message: 'Logged out successfully.'
            }, status: :ok
          else
            render json: {
              status: :unauthorized,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end
        end
      end
    end
  end
end
