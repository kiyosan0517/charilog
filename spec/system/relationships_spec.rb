require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  describe '#create,#destroy' do
    it 'ユーザーをフォロー、フォロー解除できる' do
      login(@user1)
      visit user_path(@user2)

      # フォローする
      click_on 'フォローする'
      expect(page).to have_content('フォロー解除')
      expect(@user2.followeds.count).to eq(1)
      expect(@user1.followers.count).to eq(1)

      # フォロー解除する
      click_on 'フォロー解除'
      expect(page).to have_content('フォローする')
      expect(@user2.followeds.count).to eq(0)
      expect(@user1.followers.count).to eq(0)
    end
  end
end
