module FollowSupport
  def user_and_follow_set
    search_user_set
    create(:relationship, follower_id: @user1.id, followed_id: @user2.id)
    create(:relationship, follower_id: @user2.id, followed_id: @user3.id)
    create(:relationship, follower_id: @user2.id, followed_id: @user4.id)
    create(:relationship, follower_id: @user3.id, followed_id: @user1.id)
    create(:relationship, follower_id: @user4.id, followed_id: @user2.id)
  end
end
