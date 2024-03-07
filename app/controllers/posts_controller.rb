class PostsController < ApplicationController
  include SortPosts
  include SetRakutenItems
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    sort_or_search
  end

  def likes
    @q = current_user.like_posts.ransack(params[:q])
    sort_or_search
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      save_items
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    else
      post_create_failure
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path, success: t('defaults.message.updated', item: Post.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_updated', item: Post.model_name.human)
      render :edit
    end
  end

  def destroy
    @post.images.purge
    @post.destroy!
    redirect_to posts_path, success: t('defaults.message.deleted', item: Post.model_name.human)
  end

  # 画像アップロード用のアクション
  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  def search_rakuten
    if params[:q].present?
      @rakuten_items = RakutenWebService::Ichiba::Item.search({
        keyword: params[:q],
        hits: 15
      })
    end
    respond_to do |format|
      format.js
    end
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
    params[:post][:images]&.map { |id| ActiveStorage::Blob.find(id) }
  end

  # blobデータの作成
  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end

  def sort_or_search
    if params[:order].present?
      sort_posts
    else
      search_posts
    end
  end

  def search_posts
    @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page])
    @post_count = @posts.total_count
  end

  def post_create_failure
    @post = Post.new(post_params)
    flash.now[:danger] = t('defaults.message.not_created', item: Post.model_name.human)
    render :new
  end
end
