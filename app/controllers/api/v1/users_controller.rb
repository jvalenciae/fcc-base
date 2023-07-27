# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def create
        user = User.new(user_params)
        authorize!(:create, user, message: I18n.t('unauthorized.create.user'))
        render_response(data: user, serializer: UserSerializer) if user.save!
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name, :last_name, :email, :password, :phone_number, :country, :role,
          { organization_ids: [] }, { branch_ids: [] }
        )
      end
    end
  end
end
