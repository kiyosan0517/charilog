require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  describe 'フォロー/フォロー解除' do
    it '他ユーザーをフォロー/フォロー解除できる' do
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

  describe 'ユーザー詳細内のフォロー/フォロワー情報' do
    before do
      user_and_follow_set
      login(@user1)
    end

    describe 'フォロー/フォロワー数のカウント' do
      it '各ユーザーのフォロー/フォロワー数が確認できる' do
        visit user_path(@user1)
        expect(page).to have_content('フォロワー 1人')
        expect(page).to have_content('フォロー 1人')

        visit user_path(@user2)
        expect(page).to have_content('フォロワー 2人')
        expect(page).to have_content('フォロー 2人')

        click_on 'フォロー解除'
        expect(page).to have_content('フォロワー 1人')
        expect(page).to have_content('フォロー 2人')

        visit user_path(@user1)
        expect(page).to have_content('フォロワー 1人')
        expect(page).to have_content('フォロー 0人')
      end
    end

    describe 'フォロワー一覧/フォロー一覧' do
      context 'フォロワーをクリックした場合' do
        it '各ユーザーのフォロワーが確認できる' do
          visit user_path(@user1)
          expect(page).to have_content('フォロワー 1人')

          find('.follower_index').click
          expect(page).to have_selector('.user-name', text: 'second-user')
          expect(page).to have_selector('.user-mybike', text: 'スペシャライズド')

          visit user_path(@user3)
          expect(page).to have_content('フォロワー 1人')

          find('.follower_index').click
          expect(page).to have_selector('.user-name', text: 'first-user')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')
        end
      end
      context 'フォローをクリックした場合' do
        it '各ユーザーのフォローが確認できる' do
          visit user_path(@user1)
          expect(page).to have_content('フォロー 1人')

          find('.followed_index').click
          expect(page).to have_selector('.user-name', text: 'first-user')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')

          visit user_path(@user3)
          expect(page).to have_content('フォロー 1人')

          find('.followed_index').click
          expect(page).to have_selector('.user-name', text: "#{@user1.name}")
          expect(page).to have_selector('.user-mybike', text: "#{@user1.my_bike_i18n}")
        end
      end
    end

    describe 'フォロワー/フォロー検索' do
      before do
        visit user_path(@user2)
      end

      describe 'フォロワー検索' do
        before do
          find('.follower_index').click
          expect(page).to have_selector('.user-name', text: "#{@user1.name}")
          expect(page).to have_selector('.user-mybike', text: "#{@user1.my_bike_i18n}")
          expect(page).to have_selector('.user-name', text: 'third-user')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')
          user_search_test_preparation
        end

        context 'ユーザー名/メーカー両方(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: 'third-user'
            select 'ピナレロ', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'third-user')
            expect(page).to have_selector('.user-mybike', text: 'ピナレロ')

            fill_in 'q_name_cont', with: 'mismatch-name'
            select 'アンカー', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'ユーザー名のみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: "#{@user1.name}"
            click_button '検索'
            expect(page).to have_selector('.user-name', text: "#{@user1.name}")
            expect(page).to have_selector('.user-mybike', text: "#{@user1.my_bike_i18n}")

            fill_in 'q_name_cont', with: 'mismatch-name'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'メーカーのみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: ''
            select "#{@user1.my_bike_i18n}", from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: "#{@user1.name}")
            expect(page).to have_selector('.user-mybike', text: "#{@user1.my_bike_i18n}")

            select 'アンカー', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
      end

      describe 'フォロー検索' do
        before do
          find('.followed_index').click
          expect(page).to have_selector('.user-name', text: 'second-user')
          expect(page).to have_selector('.user-mybike', text: 'スペシャライズド')
          expect(page).to have_selector('.user-name', text: 'third-user')
          expect(page).to have_selector('.user-mybike', text: 'ピナレロ')
          user_search_test_preparation
        end

        context 'ユーザー名/メーカー両方(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: 'second-user'
            select 'スペシャライズド', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'second-user')
            expect(page).to have_selector('.user-mybike', text: 'スペシャライズド')

            fill_in 'q_name_cont', with: 'mismatch-name'
            select 'アンカー', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'ユーザー名のみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: 'third-user'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'third-user')
            expect(page).to have_selector('.user-mybike', text: 'ピナレロ')

            fill_in 'q_name_cont', with: 'mismatch-name'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
        context 'メーカーのみ(一致/不一致)' do
          it '検索結果が正常に表示される' do
            fill_in 'q_name_cont', with: ''
            select 'スペシャライズド', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_selector('.user-name', text: 'second-user')
            expect(page).to have_selector('.user-mybike', text: 'スペシャライズド')

            select 'アンカー', from: 'q_my_bike_eq'
            click_button '検索'
            expect(page).to have_content('検索結果がありません')
          end
        end
      end
    end
  end
end
