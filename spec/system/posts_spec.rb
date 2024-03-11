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
    describe 'ログCRUD' do
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

    describe 'ログ検索' do
      before do
        search_user_set
        create(:post, user: @user2, title: 'test-title', content: 'test-content')
        create(:post, user: @user3, title: 'test-title', content: 'other-content')
        create(:post, user: @user4, title: 'other-title', content: 'test-content')

        login(@user1)
        visit posts_path
        post_search_test_preparation
      end

      context 'タイトルor本文/メーカー両方(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_title_or_content_cont', with: 'test'
          select 'ピナレロ', from: 'q_user_my_bike_eq'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.post-title', text: 'test-title')
          expect(page).to have_selector('.post-content', text: 'test-content')

          fill_in 'q_title_or_content_cont', with: 'no-post'
          select 'アンカー', from: 'q_user_my_bike_eq'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
      context 'タイトルor本文のみ(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_title_or_content_cont', with: 'test-title'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.post-title', text: 'test-title')
          expect(page).to have_selector('.post-content', text: 'test-content')
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.post-title', text: 'test-title')
          expect(page).to have_selector('.post-content', text: 'other-content')

          fill_in 'q_title_or_content_cont', with: 'mismatch-title-or-content'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
      context 'メーカーのみ(一致/不一致)' do
        it '検索結果が正常に表示される' do
          fill_in 'q_title_or_content_cont', with: ''
          select 'ピナレロ', from: 'q_user_my_bike_eq'
          click_button '検索'
          expect(page).to have_selector('.user-name', text: 'test')
          expect(page).to have_selector('.post-title', text: 'test-title')
          expect(page).to have_selector('.post-content', text: 'test-content')
          expect(page).to have_selector('.user-name', text: 'other-name')
          expect(page).to have_selector('.post-title', text: 'other-title')
          expect(page).to have_selector('.post-content', text: 'test-content')

          select 'アンカー', from: 'q_user_my_bike_eq'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end
    end

    describe 'ログ並び替え' do
      describe '投稿一覧/いいね一覧の並び替え' do
        before do
          post_and_like_set
          login(@user1)
        end

        describe '投稿一覧の並び替え' do
          before do
            visit posts_path
          end

          context '新着順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '新着順'
              expect(page.text).to match(/#{@user4_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
              expect(page.text).not_to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user4_post.title}/)
            end
          end
          context '古い順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '古い順'
              expect(page.text).to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user4_post.title}/)
              expect(page.text).not_to match(/#{@user4_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
            end
          end
          context 'タイトル(A~Z/50音順)で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on 'タイトル(A~Z/50音順)'
              expect(page.text).to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user4_post.title}/)
              expect(page.text).not_to match(/#{@user4_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
            end
          end
          context 'タイトル(逆50音/Z~A順)で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on 'タイトル(逆50音/Z~A順)'
              expect(page.text).to match(/#{@user4_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
              expect(page.text).not_to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}[\s\S]*#{@user4_post.title}/)
            end
          end
          context '人気順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '人気順'
              expect(page.text).to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}[\s\S]*#{@user4_post.title}/)
            end
          end
        end

        describe 'いいね一覧の並び替え' do
          before do
            visit likes_posts_path
          end

          context '新着順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '新着順'
              expect(page.text).to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
              expect(page.text).not_to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}/)
            end
          end
          context '古い順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '古い順'
              expect(page.text).to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}/)
              expect(page.text).not_to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
            end
          end
          context 'タイトル(A~Z/50音順)で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on 'タイトル(A~Z/50音順)'
              expect(page.text).to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}/)
              expect(page.text).not_to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
            end
          end
          context 'タイトル(逆50音/Z~A順)で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on 'タイトル(逆50音/Z~A順)'
              expect(page.text).to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
              expect(page.text).not_to match(/#{@user2_post.title}[\s\S]*#{@user3_post.title}/)
            end
          end
          context '人気順で並び替える' do
            it '並び替えが正常に機能する' do
              find('#dropdownMenuButton1').click
              click_on '人気順'
              expect(page.text).to match(/#{@user3_post.title}[\s\S]*#{@user2_post.title}/)
            end
          end
        end
      end

      describe '各ユーザーの投稿の並び替え' do
        before do
          user_post_and_like_set
          login(@user1)
          visit user_path(@user2)
        end

        context '新着順で並び替える' do
          it '並び替えが正常に機能する' do
            find('#dropdownMenuButton1').click
            click_on '新着順'
            expect(page.text).to match(/#{@user2_post2.title}[\s\S]*#{@user2_post1.title}/)
            expect(page.text).not_to match(/#{@user2_post1.title}[\s\S]*#{@user2_post2.title}/)
          end
        end
        context '古い順で並び替える' do
          it '並び替えが正常に機能する' do
            find('#dropdownMenuButton1').click
            click_on '古い順'
            expect(page.text).to match(/#{@user2_post1.title}[\s\S]*#{@user2_post2.title}/)
            expect(page.text).not_to match(/#{@user2_post2.title}[\s\S]*#{@user2_post1.title}/)
          end
        end
        context 'タイトル(A~Z/50音順)で並び替える' do
          it '並び替えが正常に機能する' do
            find('#dropdownMenuButton1').click
            click_on 'タイトル(A~Z/50音順)'
            expect(page.text).to match(/#{@user2_post1.title}[\s\S]*#{@user2_post2.title}/)
            expect(page.text).not_to match(/#{@user2_post2.title}[\s\S]*#{@user2_post1.title}/)
          end
        end
        context 'タイトル(逆50音/Z~A順)で並び替える' do
          it '並び替えが正常に機能する' do
            find('#dropdownMenuButton1').click
            click_on 'タイトル(逆50音/Z~A順)'
            expect(page.text).to match(/#{@user2_post2.title}[\s\S]*#{@user2_post1.title}/)
            expect(page.text).not_to match(/#{@user2_post1.title}[\s\S]*#{@user2_post2.title}/)
          end
        end
        context '人気順で並び替える' do
          it '並び替えが正常に機能する' do
            find('#dropdownMenuButton1').click
            click_on '人気順'
            expect(page.text).to match(/#{@user2_post1.title}[\s\S]*#{@user2_post2.title}/)
          end
        end
      end
    end
  end
end
