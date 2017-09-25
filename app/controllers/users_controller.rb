class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user

  authorize_resource id_param: :username

  respond_to :json

  def show; end

  def edit; end

  def update
    update_resource @user
  end

  def logins
    authorize! :logins, @user
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :username, :email, :website, :age, :location, :full_name)
  end

  def set_user
    @user = User.find_by(username: params[:username])
  end
end
