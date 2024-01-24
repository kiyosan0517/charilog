class PostsController < ApplicationController
  before_action :set_post, only: %i[ edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts or /posts.json
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

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/1/edit
  def edit; end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to posts_path, success: t("defaults.message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.message.not_updated", item: Post.model_name.human)
      render :edit
    end
  end

  # DELETE /posts/1 or /posts/1.json
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

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = current_user.posts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
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
end
