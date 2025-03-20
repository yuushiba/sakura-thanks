require 'rails_helper'

RSpec.describe 'ユーザーセッション', type: :system do
  let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  describe 'ログイン' do
    it '正しい情報でログインできること' do
      visit login_path

      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
    end
  end
end
