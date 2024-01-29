class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).with_attached_avatar.where.not(id: current_user.id).order(created_at: :desc).page(params[:page]).per(15)
  end

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

  def show
    @user = User.find(params[:id])
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def follows
    @user = User.find(params[:id])
    @q = @user.following_users.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(15)
  end

  def followers
    @user = User.find(params[:id])
    @q = @user.follower_users.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(15)
  end

  private

  def user_params
    params.require(:user).permit(:name, :my_bike, :email, :password, :password_confirmation, :avatar)
  end
end
