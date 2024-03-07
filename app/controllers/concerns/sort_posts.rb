module SortPosts
  def sort_posts
    if params[:order] != 'like_desc'
      @posts = @q.result(distinct: true)
                 .includes(user: { avatar_attachment: :blob })
                 .with_attached_images
                 .order(SORT_ORDERS.fetch(params[:order]))
                 .page(params[:page])
    else
      sort_posts_by_like_desc
    end
  end

  def sort_user_posts
    if params[:order] != 'like_desc'
      @posts = @user.posts
                    .includes(user: { avatar_attachment: :blob })
                    .with_attached_images
                    .order(SORT_ORDERS.fetch(params[:order]))
                    .page(params[:page])
    else
      sort_user_posts_by_like_desc
    end
  end

  private

  def sort_posts_by_like_desc
    @posts = @q.result(distinct: true)
               .left_joins(:likes)
               .select('posts.*, COUNT(likes.id) AS like_count')
               .group('posts.id')
               .includes(user: { avatar_attachment: :blob })
               .with_attached_images
               .order('like_count DESC')
               .page(params[:page])
  end

  def sort_user_posts_by_like_desc
    @posts = @user.posts
                  .left_joins(:likes)
                  .select('posts.*, COUNT(likes.id) AS like_count')
                  .group('posts.id')
                  .includes(user: { avatar_attachment: :blob })
                  .with_attached_images
                  .order('like_count DESC')
                  .page(params[:page])
  end

  SORT_ORDERS = {
    'new' => 'created_at DESC',
    'old' => 'created_at ASC',
    'title_desc' => 'title DESC',
    'title_asc' => 'title ASC'
  }.freeze
end
