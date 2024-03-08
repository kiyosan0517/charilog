require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context '入力値が正常' do
        it '新規登録が成功する' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録する'
          expect(current_path).to eq(posts_path)
          expect(page).to have_content('ユーザー登録が完了しました')
        end
      end
      context 'ユーザー名未入力' do
        it '新規登録が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: ''
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録する'
          expect(current_path).to eq(users_path)
          expect(page).to have_content('ユーザー登録に失敗しました')
          expect(page).to have_content('ユーザー名を入力してください')
        end
      end
      context 'メールアドレス未入力' do
        it '新規登録が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録する'
          expect(current_path).to eq(users_path)
          expect(page).to have_content('ユーザー登録に失敗しました')
          expect(page).to have_content('メールアドレスを入力してください')
        end
      end
      context 'メールアドレス重複' do
        it '新規登録が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録する'
          expect(current_path).to eq(users_path)
          expect(page).to have_content('ユーザー登録に失敗しました')
          expect(page).to have_content('メールアドレスはすでに存在します')
        end
      end
      context 'パスワードとパスワード確認が不一致' do
        it '新規登録が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'testtest'
          click_button '登録する'
          expect(current_path).to eq(users_path)
          expect(page).to have_content('ユーザー登録に失敗しました')
          expect(page).to have_content('パスワード確認とパスワードの入力が一致しません')
        end
      end
      context 'パスワードが7字以下' do
        it '新規登録が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'test'
          fill_in 'パスワード確認', with: 'test'
          click_button '登録する'
          expect(current_path).to eq(users_path)
          expect(page).to have_content('ユーザー登録に失敗しました')
          expect(page).to have_content('パスワードは8文字以上で入力してください')
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'プロフィール編集' do
      before do
        login(user)
      end

      context '入力値が正常' do
        it '更新が成功する' do
          visit edit_profile_path(user)
          fill_in 'ユーザー名', with: 'test'
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in '自己紹介', with: 'Hi Hellow'
          click_on '更新する'
          expect(current_path).to eq(user_path(user))
          expect(page).to have_content('プロフィールを更新しました')
        end
      end
      context 'ユーザー名が未入力' do
        it '更新が失敗する' do
          visit edit_profile_path(user)
          fill_in 'ユーザー名', with: ''
          select 'PINARELLO', from: 'user[my_bike]'
          fill_in '自己紹介', with: 'Hi Hellow'
          click_on '更新する'
          expect(current_path).to eq(profile_path)
          expect(page).to have_content('プロフィールの更新に失敗しました')
          expect(page).to have_content('ユーザー名を入力してください')
        end
      end
    end

    describe 'ユーザー検索' do
      before do
        search_user_set
        login(@user1)
        visit users_path
        user_search_test_preparation
      end

      context 'ユーザー名/メーカー両方(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_name_cont', with: 'test'
          select 'ピナレロ', from: 'q_my_bike_eq'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')

          fill_in 'q_name_cont', with: 'mismatch-name'
          select 'アンカー', from: 'q_my_bike_eq'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
      context 'ユーザー名のみ(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_name_cont', with: 'test'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.user-mybike', text: 'スペシャライズド')

          fill_in 'q_name_cont', with: 'mismatch-name'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
      context 'メーカーのみ(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_name_cont', with: ''
          select 'ピナレロ', from: 'q_my_bike_eq'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')
          expect(page).to have_selector('.user-name', text: 'other-name')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')

          select 'アンカー', from: 'q_my_bike_eq'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
    end
  end
end
