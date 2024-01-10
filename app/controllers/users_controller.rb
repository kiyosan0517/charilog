class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to posts_path, flash: { warning: 'ログインしました' }
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :my_bike, :email, :password, :password_confirmation, :avatar)
  end

end
