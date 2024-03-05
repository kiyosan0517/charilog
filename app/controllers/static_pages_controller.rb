class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def top
    @posts = Post.includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).limit(3)

    redirect_to posts_path if logged_in?
  end

  def privacy_policy; end

  def terms; end
end
