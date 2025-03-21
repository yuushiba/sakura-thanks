require 'capybara/rspec'

# CI環境かどうかを判定
is_ci = ENV['CI'].present?

# システムテスト設定
RSpec.configure do |config|
  config.before(:each, type: :system) do
    # 環境変数から接続先を取得するか、デフォルト値を使用
    remote_url = ENV['SELENIUM_REMOTE_URL'] || 'http://selenium_chrome:4444/wd/hub'

    # Seleniumドライバー設定
    driven_by :selenium_remote_chrome, screen_size: [ 1400, 1400 ]

    # ドライバーの登録（前に追加）
    Capybara.register_driver :selenium_remote_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')

      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: remote_url,
        capabilities: options
      )
    end

    # サーバー設定
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4000
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  # 接続エラー時のリトライロジック
  config.around(:each, type: :system) do |example|
    retry_count = 0
    begin
      example.run
    rescue Socket::ResolutionError => e
      if retry_count < 3
        retry_count += 1
        puts "名前解決エラー: #{retry_count}回目のリトライ..."
        sleep 5
        retry
      else
        puts "3回リトライしましたが、接続できませんでした。"
        raise e
      end
    end
  end
end
