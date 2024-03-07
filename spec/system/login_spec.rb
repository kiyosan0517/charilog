require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    context '入力値が正常' do
      it 'ログインが成功する' do
        login(user)
        expect(current_path).to eq posts_path
        expect(page).to have_content('ログインしました')
      end
    end
    context 'フォーム未入力' do
      it 'ログインが失敗する' do
        visit root_path
        click_button 'ログイン'
        expect(current_path).to eq root_path
        expect(page).to have_content('ログインに失敗しました')
      end
    end
  end

  describe 'ログアウト' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウトに成功する' do
        login(user)
        click_link 'ログアウト'
        accept_alert
        expect(current_path).to eq root_path
        expect(page).to have_content('ログアウトしました')
      end
    end
  end
end
