# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.accessible_by(current_ability)
        render_response(data: @users, serializer: UserSerializer)
      end

      def show
        authorize!(:read, @user, message: I18n.t('unauthorized.read.user'))
        render_response(data: @user, serializer: UserSerializer)
      end

      def create
        @user = User.new(user_params)
        authorize!(:create, @user, message: I18n.t('unauthorized.create.user'))
        render_response(data: @user, serializer: UserSerializer) if @user.save!
      end

      def update
        @user.assign_attributes(user_params)
        authorize!(:update, @user, message: I18n.t('unauthorized.update.user'))
        render_response(data: @user, serializer: UserSerializer) if @user.save!
      end

      def destroy
        authorize!(:destroy, @user, message: I18n.t('unauthorized.destroy.user'))
        render json: { message: 'User successfully deleted.' }, status: :ok if @user.destroy!
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :first_name, :last_name, :email, :password, :phone_number, :country, :role,
          { organization_ids: [] }, { branch_ids: [] }
        )
      end
    end
  end
end
