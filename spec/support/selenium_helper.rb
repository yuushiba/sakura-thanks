require 'capybara/rspec'

# ドライバーの登録
Capybara.register_driver :selenium_remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  # 環境変数からURLを取得（CI環境では localhost、それ以外では selenium_chrome）
  remote_url = ENV['CI'] ? 'http://localhost:4444/wd/hub' : 'http://selenium_chrome:4444/wd/hub'

  puts "🔍 使用するSeleniumURL: #{remote_url}"  # デバッグ用ログ

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: remote_url,
    capabilities: options
  )
end

# システムテスト設定
RSpec.configure do |config|
  if ENV['CI']
    config.filter_run_excluding type: :system
  end

  config.before(:each, type: :system) do
    driven_by :selenium_remote_chrome, screen_size: [ 1400, 1400 ]

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
    rescue => e
      if retry_count < 3 && (e.is_a?(Socket::ResolutionError) || e.message.include?('failed to open TCP connection'))
        retry_count += 1
        puts "⚠️ 接続エラー: #{e.message}"
        puts "🔄 #{retry_count}回目のリトライ中..."
        sleep 5
        retry
      else
        raise e
      end
    end
  end
end
