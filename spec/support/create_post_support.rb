module CreatePostSupport
  def post_create_and_redirect
    create(:post, user: user)
    visit posts_path
  end

  def others_post_create_and_redirect
    @post = create(:post)
    visit post_path(@post)
  end
end
