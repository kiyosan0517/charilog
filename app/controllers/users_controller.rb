class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show follows followers]

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
      redirect_to posts_path, success: t(".success")
    else
      flash.now[:danger] = t(".fail")
      render :new
      @user = User.new(user_params)
    end
  end

  def show
    @like_count = @user.posts_all_like_count
    @following_users = @user.following_users.includes(avatar_attachment: :blob)
    @follower_users = @user.follower_users.includes(avatar_attachment: :blob)
    unless params[:order]
      @posts = @user.posts.includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page]).per(10)
    else
      sort_posts
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

  private

  def load_users
    @users = @q.result(distinct: true).with_attached_avatar.where.not(id: current_user.id).order(created_at: :desc).page(params[:page]).per(15)
    @user_count = @users.total_count
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :my_bike, :email, :password, :password_confirmation, :avatar)
  end

  def sort_posts
    case params[:order]
    when 'new'
      @posts = @user.posts.includes(user: { avatar_attachment: :blob }).with_attached_images.order('created_at DESC').page(params[:page]).per(10)
    when 'old'
      @posts = @user.posts.includes(user: { avatar_attachment: :blob }).with_attached_images.order('created_at ASC').page(params[:page])
    when 'title_desc'
      @posts = @user.posts.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('title DESC').page(params[:page])
    when 'title_asc'
      @posts = @user.posts.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('title ASC').page(params[:page])
    else 'like_desc'
      @posts = @user.posts.result(distinct: true).left_joins(:likes).select("posts.*, COUNT(likes.id) AS like_count").group("posts.id").includes(user: { avatar_attachment: :blob }).with_attached_images.order("like_count DESC").page(params[:page])
    end
  end
end
