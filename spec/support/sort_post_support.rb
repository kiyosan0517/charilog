module SortPostSupport
  def post_and_like_set
    search_user_set
    @user2_post = create(:post, user: @user2, title: 'first-title', content: 'first-content')
    @user3_post = create(:post, user: @user3, title: 'second-title', content: 'second-content')
    @user4_post = create(:post, user: @user4, title: 'third-title', content: 'third-content')
    create(:like, user: @user1, post: @user3_post)
    create(:like, user: @user1, post: @user2_post)
    create(:like, user: @user2, post: @user3_post)
  end

  def user_post_and_like_set
    search_user_set
    @user2_post1 = create(:post, user: @user2, title: 'first-title', content: 'first-content')
    @user2_post2 = create(:post, user: @user2, title: 'second-title', content: 'second-content')
    create(:like, user: @user1, post: @user2_post1)
    create(:like, user: @user1, post: @user2_post2)
    create(:like, user: @user3, post: @user2_post1)
  end
end
