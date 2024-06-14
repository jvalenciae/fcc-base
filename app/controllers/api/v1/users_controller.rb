# frozen_string_literal: true

class Api::V1::UsersController < ApiController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.accessible_by(current_ability)
    render json: @users, each_serializer: UserSerializer
  end

  def show
    authorize!(:read, @user, message: I18n.t('unauthorized.read.user'))
    render json: @user, serializer: UserSerializer
  end

  def create
    @user = User.new(user_params)
    authorize!(:create, @user, message: I18n.t('unauthorized.create.user'))
    return unless @user.save!

    UserMailer.invitation(@user, current_user).deliver_later
    render json: @user, serializer: UserSerializer
  end

  def update
    @user.assign_attributes(user_params)
    authorize!(:update, @user, message: I18n.t('unauthorized.update.user'))
    render json: @user, serializer: UserSerializer if @user.save!
  end

  def destroy
    authorize!(:destroy, @user, message: I18n.t('unauthorized.destroy.user'))
    render json: { message: I18n.t('user.successful_delete') }, status: :ok if @user.destroy!
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :country, :role
    )
  end
end
