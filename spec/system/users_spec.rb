require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  describe 'ユーザー新規登録' do
    context '適切な値を入力した場合' do
      # この1つのテストだけCI環境で実行するためにタグを付ける
      it 'ユーザー登録に成功する', first_ci_system_test: true do
        visit new_user_path

        # フォームに値を入力
        fill_in 'ユーザーネーム', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード再入力', with: 'password'

        # 登録ボタンをクリック
        click_button '登録'

        # 登録成功のメッセージが表示されることを確認
        expect(page).to have_content 'ユーザー登録が完了しました'

        # 実際にユーザーが作成されたことを確認
        expect(User.last.name).to eq 'テストユーザー'
      end
    end

    context '名前が未入力の場合' do
      it 'エラーメッセージが表示される' do
        visit new_user_path

        # 名前を空で送信
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード再入力', with: 'password'
        click_button '登録'

        # エラーメッセージの確認
        expect(page).to have_content '名前を入力してください'
      end
    end
  end
end
