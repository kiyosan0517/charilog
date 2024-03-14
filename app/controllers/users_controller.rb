class UsersController < ApplicationController
  include SortPosts
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :follows, :followers]

  def index
    @q = User.ransack(params[:q])
    load_users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to posts_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
      @user = User.new(user_params)
    end
  end

  def show
    @like_count = @user.posts_all_like_count
    @following_users = @user.following_users.includes(avatar_attachment: :blob)
    @follower_users = @user.follower_users.includes(avatar_attachment: :blob)
    if params[:order]
      sort_user_posts
    else
      @posts = @user.posts.includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def follows
    @q = @user.following_users.ransack(params[:q])
    load_users
  end

  def followers
    @q = @user.follower_users.ransack(params[:q])
    load_users
  end

  def search
    @users = User.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  private

  def load_users
    @users = @q.result(distinct: true).with_attached_avatar.order(created_at: :desc).page(params[:page]).per(10)
    @user_count = @users.total_count
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :my_bike, :email, :password, :password_confirmation, :avatar)
  end
end
