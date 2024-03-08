module UserSearchFilterSupport
  def search_test_preparation
    fill_in 'q_name_cont', with: 'no-user'
    click_button '検索'
    expect(page).to have_content('検索結果がありません')
  end
end
