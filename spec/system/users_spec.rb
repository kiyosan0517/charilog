require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ユーザー新規登録' do
    context '入力値が正常' do
      it '新規登録が成功する' do
        visit new_user_path
        fill_in 'ユーザーネーム', with: 'test'
        select 'PINARELLO', from: 'user[my_bike]'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録する'
        expect(current_path).to eq(posts_path)
        expect(page).to have_content('ログインしました')
      end
    end
    context 'ユーザーネーム未入力' do
      it '新規登録が失敗する' do
        visit new_user_path
        select 'PINARELLO', from: 'user[my_bike]'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録する'
        expect(current_path).to eq(users_path)
        expect(page).to have_content('登録に失敗しました')
        expect(page).to have_content('ユーザーネームを入力してください')
      end
    end
    context 'メールアドレス未入力' do
      it '新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザーネーム', with: 'test'
        select 'PINARELLO', from: 'user[my_bike]'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録する'
        expect(current_path).to eq(users_path)
        expect(page).to have_content('登録に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
      end
    end
    context 'メールアドレス重複' do
      it '新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザーネーム', with: 'test'
        select 'PINARELLO', from: 'user[my_bike]'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録する'
        expect(current_path).to eq(users_path)
        expect(page).to have_content('登録に失敗しました')
        expect(page).to have_content('メールアドレスはすでに存在します')
      end
    end
    context 'パスワードが7字以下' do
      it '新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザーネーム', with: 'test'
        select 'PINARELLO', from: 'user[my_bike]'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'test'
        fill_in 'パスワード確認', with: 'test'
        click_button '登録する'
        expect(current_path).to eq(users_path)
        expect(page).to have_content('登録に失敗しました')
        expect(page).to have_content('パスワードは8文字以上で入力してください')
      end
    end
  end

end