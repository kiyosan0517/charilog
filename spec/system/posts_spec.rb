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

      describe 'ログの投稿(タグの設定/編集/検索まで)' do
        it '各投稿にタグを紐付けられる' do
          visit new_post_path
          fill_in 'ログタイトル', with: 'test-title'
          fill_in 'タグ設定', with: 'test1'
          click_button '投稿する'
          expect(page).to have_content('test1')
          expect(page).to have_content('ログを作成しました')

          fill_in 'q_tags_name_cont', with: 'test2'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')

          fill_in 'q_tags_name_cont', with: 'test1'
          click_button '検索'
          expect(page).to have_content('検索結果:1件')
          expect(page).to have_content('test1')

          find('.fa-pencil-alt').click
          fill_in 'タグ設定', with: 'test2'
          click_button '更新する'
          expect(page).to have_content('test2')
          expect(page).to have_content('ログを更新しました')

          fill_in 'q_tags_name_cont', with: 'test2'
          click_button '検索'
          expect(page).to have_content('検索結果:1件')
          expect(page).to have_content('test2')

          fill_in 'q_tags_name_cont', with: 'test1'
          click_button '検索'
          expect(page).to have_content('検索結果がありません')
        end
      end

      describe 'ログの投稿(楽天アイテム紐付け)', js: true do
        it '各投稿に楽天アイテムを紐付けられる' do
          visit new_post_path
          fill_in 'ログタイトル', with: 'test-title'
          fill_in 'ログ内容', with: 'test-content'

          find('#rakuten-link-button').click
          within '.rakuten-search-area' do
            fill_in 'q', with: 'ruby postgres'
            click_button '検索'
          end
          click_on '選択'
          click_button 'Close'

          click_button '投稿する'

          expect(page).to have_css('.items_count', text: '1')

          find('.card-body').click
          expect(page).to have_content('参考価格：18,119円')
          expect(page).to have_content('楽天商品ページへ')
        end
      end

      describe 'コメント追加/削除' do
        context '入力値が正常' do
          it 'コメントの追加/削除が成功する' do
            post_create_and_redirect
            find('.card-body').click
            fill_in 'js-new-comment-body', with: 'test-comment'
            click_button '送信'
            expect(page).to have_content('test-comment')
            expect(page).to have_content('コメントを作成しました')

            find('.text-black-50').click
            accept_alert
            expect(page).to have_content('コメントはまだありません')
          end
        end
        context 'コメント未入力' do
          it 'コメントの追加に失敗する(送信ボタンが押せない)' do
            post_create_and_redirect
            find('.card-body').click
            fill_in 'js-new-comment-body', with: ''
            expect(page).to have_button('送信', disabled: true)
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
            click_button '更新する'
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
            click_button '更新する'
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

    describe 'ログ検索(ログ一覧/いいね一覧)' do
      before do
        post_and_like_set
        login(@user1)
      end

      describe 'ログ一覧上での検索' do
        before do
          visit posts_path
          post_search_test_preparation
        end

        context 'タイトルor本文/メーカー両方(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_title_or_content_cont', with: 'first-title'
            select 'ピナレロ', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'first-user')
            expect(page).to have_selector('.post-title', text: 'first-title')
            expect(page).to have_selector('.post-content', text: 'first-content')

            fill_in 'q_title_or_content_cont', with: 'no-post'
            select 'アンカー', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'タイトルor本文のみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_title_or_content_cont', with: 'second-title'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'second-user')
            expect(page).to have_selector('.post-title', text: 'second-title')
            expect(page).to have_selector('.post-content', text: 'second-content')

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
            expect(page).to have_selector('.user-name', text: 'first-user')
            expect(page).to have_selector('.post-title', text: 'first-title')
            expect(page).to have_selector('.post-content', text: 'first-content')
            expect(page).to have_selector('.user-name', text: 'third-user')
            expect(page).to have_selector('.post-title', text: 'third-title')
            expect(page).to have_selector('.post-content', text: 'third-content')

            select 'アンカー', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
      end

      describe 'いいね一覧上での検索' do
        before do
          visit likes_posts_path
          post_search_test_preparation
        end

        context 'タイトルor本文/メーカー両方(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_title_or_content_cont', with: 'first-title'
            select 'ピナレロ', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'first-user')
            expect(page).to have_selector('.post-title', text: 'first-title')
            expect(page).to have_selector('.post-content', text: 'first-content')

            fill_in 'q_title_or_content_cont', with: 'no-post'
            select 'アンカー', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'タイトルor本文のみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_title_or_content_cont', with: 'second-title'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'second-user')
            expect(page).to have_selector('.post-title', text: 'second-title')
            expect(page).to have_selector('.post-content', text: 'second-content')

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
            expect(page).to have_selector('.user-name', text: 'first-user')
            expect(page).to have_selector('.post-title', text: 'first-title')
            expect(page).to have_selector('.post-content', text: 'first-content')

            select 'アンカー', from: 'q_user_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
      end
    end

    describe 'ログ並び替え' do
      describe 'ログ一覧/いいね一覧の並び替え' do
        before do
          post_and_like_set
          login(@user1)
        end

        describe 'ログ一覧の並び替え' do
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

      describe '各ユーザーのログの並び替え' do
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
