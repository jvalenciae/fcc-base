# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.accessible_by(current_ability).excluding(current_user)
        fetch_and_render_users(Users::UserSerializer)
      end

      def show
        authorize!(:read, @user, message: I18n.t('unauthorized.read.user'))
        render_response(data: @user, serializer: Users::UserSerializer)
      end

      def create
        @user = User.new(user_params)
        authorize!(:create, @user, message: I18n.t('unauthorized.create.user'))
        return unless @user.save!

        UserMailer.invitation(@user, current_user).deliver_later
        render_response(data: @user, serializer: Users::UserSerializer)
      end

      def update
        @user.assign_attributes(user_params)
        authorize!(:update, @user, message: I18n.t('unauthorized.update.user'))
        render_response(data: @user, serializer: Users::UserSerializer) if @user.save!
      end

      def destroy
        authorize!(:destroy, @user, message: I18n.t('unauthorized.destroy.user'))
        render json: { message: I18n.t('user.successful_delete') }, status: :ok if @user.destroy!
      end

      def members
        @users = User.accessible_by(current_ability).by_role('member')
        fetch_and_render_users(Users::MemberSerializer)
      end

      def roles
        super_admin_roles = User::SUPER_ADMIN_ROLES.keys
        admin_roles = User::ADMIN_ROLES.keys
        member_roles = User::MEMBER_ROLES.keys
        @roles = {
          super_admin: super_admin_roles,
          admin: admin_roles,
          member: member_roles
        }
        render_response(data: @roles)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :country, :role,
          :organization_id, { branch_ids: [] }
        )
      end

      def fetch_and_render_users(serializer)
        @users = UsersFilterService.call(@users, params)
        @users, meta = paginate_resources(@users)
        render_response(data: @users, serializer: serializer, meta: meta)
      end
    end
  end
end
