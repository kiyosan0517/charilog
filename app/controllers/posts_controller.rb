class PostsController < ApplicationController
  before_action :set_post, only: %i[ edit update destroy ]

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
    redirect_to user_path(user), success: t("defaults.message.deleted", item: Post.model_name.human)
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
        hits: 15,
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

  def sort_or_search
    if params[:order].present?
      sort_posts
    else
      search_posts
    end
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

  def search_posts
    @posts = @q.result(distinct: true).includes(user: { avatar_attachment: :blob }).with_attached_images.order(created_at: :desc).page(params[:page])
    @post_count = @posts.total_count
  end

  def save_items
    items_params&.each do |item|
      item_data = JSON.parse(item)

      if Item.exists?(item_code: item_data['item_code'])
        item = Item.find_by(item_code: item_data['item_code'])
        @post.post_items.create!(item: item)
      else
        item = Item.create(name: item_data['name'], 
                           price: item_data['price'], 
                           rakuten_url: item_data['rakuten_url'], 
                           image: item_data['image'], 
                           item_code: item_data['item_code']
                          )
        @post.post_items.create!(item: item)
      end
    end
  end

  def items_params
    items = (params[:post][:items1] + params[:post][:items2] + params[:post][:items3] + params[:post][:items4]).reject(&:empty?)
    if items.empty?
      nil
    else
      items
    end
  end
end
