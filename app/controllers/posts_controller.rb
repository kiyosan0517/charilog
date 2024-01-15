class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, flash: { success: 'ログを投稿しました' }
    else
      flash.now[:danger] = 'ログの投稿に失敗しました'
      render :new
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to posts_path, flash: { warning: 'ログを更新しました' }
    else
      flash.now[:danger] = 'ログの更新に失敗しました'
      render :edit
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
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
    @post = Post.find(params[:id])
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

end
