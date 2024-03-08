module SearchFilterSupport
  def user_search_test_preparation
    fill_in 'q_name_cont', with: 'no-user'
    click_button '検索'
    expect(page).to have_content('検索結果がありません')
  end

  def post_search_test_preparation
    fill_in 'q_title_or_content_cont', with: 'no-post'
    click_button '検索'
    expect(page).to have_content('検索結果がありません')
  end

  def search_user_set
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user, name: 'test', my_bike: 'PINARELLO（ピナレロ）')
    @user3 = FactoryBot.create(:user, name: 'test', my_bike: 'SPECIALIZED（スペシャライズド）')
    @user4 = FactoryBot.create(:user, name: 'other-name', my_bike: 'PINARELLO（ピナレロ）')
  end
end
