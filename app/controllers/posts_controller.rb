class PostsController < ApplicationController
  before_action :set_post, only: %i[ edit update destroy ]

  def index
    @q = Post.ransack(params[:q])

    if params[:order].present?
      sort_posts
    else
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page])
      @post_count = @posts.total_count
    end
  end

  def likes
    @q = current_user.like_posts.ransack(params[:q])

    if params[:order].present?
      sort_posts
    else
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page])
      @post_count = @posts.total_count
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, success: t("defaults.message.created", item: Post.model_name.human)
    else
      @post = Post.new(post_params)
      flash.now[:danger] = t("defaults.message.not_created", item: Post.model_name.human)
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path, success: t("defaults.message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.message.not_updated", item: Post.model_name.human)
      render :edit
    end
  end

  def destroy
    user = @post.user
    @post.images.purge
    @post.destroy!

    if came_from_user_show?
      redirect_to user_path(user), success: t("defaults.message.deleted", item: Post.model_name.human)
    else
      redirect_to posts_path, success: t("defaults.message.deleted", item: Post.model_name.human)
    end
  end

  # 画像アップロード用のアクション
  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, images: []).merge(images: uploaded_images)
  end

    # アップロード済み画像の検索
  def uploaded_images
    params[:post][:images].map { |id| ActiveStorage::Blob.find(id) } if params[:post][:images]
  end

  # blobデータの作成
  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end

  def came_from_user_show?
    referer = request.referer
    referer.present? && referer.include?('users')
  end

  def sort_posts
    case params[:order]
    when 'new'
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('created_at DESC').page(params[:page])
    when 'old'
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('created_at ASC').page(params[:page])
    when 'title_desc'
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('title DESC').page(params[:page])
    when 'title_asc'
      @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order('title ASC').page(params[:page])
    else 'like_desc'
      @posts = @q.result(distinct: true).left_joins(:likes).select("posts.*, COUNT(likes.id) AS like_count").group("posts.id").includes(user: { avatar_attachment: :blob }).with_attached_images.order("like_count DESC").page(params[:page])
    end
  end
end
