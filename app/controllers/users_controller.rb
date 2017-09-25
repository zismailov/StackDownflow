class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :logins]
  before_action :set_user
  before_action :user_is_current_user?, except: [:show, :logins]

  authorize_resource

  respond_to :json

  def show; end

  def edit; end

  def update
    update_resource @user
  end

  def logins
    authorize! :logins, current_user
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :username, :email, :website, :age, :location, :full_name)
  end

  def set_user
    @user = User.find_by(username: params[:username])
  end

  def user_is_current_user?
    return unless @user == current_user
    respond_with do |format|
      format.json { render json: nil, status: 403 }
      format.html { redirect_to @user }
    end
  end
end
