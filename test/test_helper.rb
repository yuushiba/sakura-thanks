ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # テストユーザーのログイン状態をシミュレートするヘルパーメソッド
    def log_in(user)
      post login_path, params: {
        email: user.email,
        password: "password"  # fixtureで設定するパスワード
      }
    end

    # ユーザーがログインしているかどうかを確認するヘルパーメソッド
    def logged_in?
      !session[:user_id].nil?
    end
  end
end
