class UsersController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :set_user
  before_action :user_is_current_user?, only: :update

  respond_to :json

  def show; end

  def update
    update_resource @user
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end

  def set_user
    @user = User.find_by(username: params[:username])
  end

  def user_is_current_user?
    render json: nil, status: 403 unless @user == current_user
  end
end