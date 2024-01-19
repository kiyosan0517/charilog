class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to posts_path, success: t(".success")
    else
      flash.now[:danger] = t(".fail")
      render :new
      @user = User.new(user_params)
    end
  end

  def show; end

  private

  def user_params
    params.require(:user).permit(:name, :my_bike, :email, :password, :password_confirmation, :avatar)
  end
end
