require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe '最新の投稿' do
      context '投稿がある場合' do
        it '最新の投稿が表示' do
          post = create(:post)
          visit root_path
          expect(page).to have_content(post.user.name)
          expect(page).to have_content(post.likes.count)
          expect(page).to have_content(post.items.count)
          expect(page).to have_content(post.title)
        end
      end
      context '投稿がない場合' do
        it 'ログがまだありませんとのテキストが表示' do
          visit root_path
          expect(page).to have_content('ログがまだありません')
          expect(page).to have_content('最初にログを残そう！')
        end
      end
      context '投稿がない、かつ最初にログを残そう！を押した場合' do
        it 'ログインが要求される' do
          visit root_path
          click_on '最初にログを残そう！'
          expect(current_path).to eq(root_path)
          expect(page).to have_content('ログインしてください')
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
    end

    describe 'ログの投稿' do
      context '入力値が正常' do
        it 'ログの投稿が成功する' do
          visit new_post_path
          fill_in 'ログタイトル', with: 'test-title'
          fill_in 'ログ内容', with: 'test-content'
          click_button '投稿する'
          expect(current_path).to eq(posts_path)
          expect(page).to have_content('ログを作成しました')
        end
      end
      context 'ログタイトル未入力' do
        it 'ログの投稿が失敗する' do
          visit new_post_path
          fill_in 'ログタイトル', with: ''
          fill_in 'ログ内容', with: 'test-content'
          click_button '投稿する'
          expect(page).to have_content('ログの作成に失敗しました')
          expect(page).to have_content('ログタイトルを入力してください')
        end
      end
    end

    describe 'ログの編集' do
      context '入力値が正常' do
        it 'ログの編集が成功する' do
          post_create_and_redirect
          find('.fa-pencil-alt').click
          fill_in 'ログタイトル', with: 'edit-test-title'
          fill_in 'ログ内容', with: 'edit-test-content'
          click_button '編集する'
          expect(current_path).to eq(posts_path)
          expect(page).to have_content('ログを更新しました')
        end
      end
      context 'ログタイトル未入力' do
        it 'ログの編集が失敗する' do
          post_create_and_redirect
          find('.fa-pencil-alt').click
          fill_in 'ログタイトル', with: ''
          fill_in 'ログ内容', with: 'edit-test-content'
          click_button '編集する'
          expect(page).to have_content('ログの更新に失敗しました')
          expect(page).to have_content('ログタイトルを入力してください')
        end
      end
    end

    describe 'ログの削除' do
      context '自身のログ削除を要求した場合' do
        it 'ログが削除できる' do
          post_create_and_redirect
          find('.fa-trash').click
          accept_alert
          expect(current_path).to eq(posts_path)
          expect(page).to have_content('ログを削除しました')
        end
      end
    end
  end
end
