require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  let(:user) { create(:user) }

  describe 'いいね/いいね解除' do
    before do
      login(user)
    end

    it '他ユーザーの投稿にいいね/いいね解除できる' do
      others_post_create_and_redirect

      # いいね
      find('.heart-empty').click
      expect(page).to have_selector('.heart')
      expect(page).to have_content('1 Likes')

      # いいね解除
      find('.heart').click
      expect(page).to have_selector('.heart-empty')
      expect(page).to have_content('0 Likes')
    end
  end
end
