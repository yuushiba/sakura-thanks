require 'capybara/rspec'

# CI環境ではシステムテストをスキップする
RSpec.configure do |config|
  # CI環境ではシステムテストをスキップ
  config.filter_run_excluding type: :system if ENV['CI']

  # 非CI環境でのシステムテスト設定
  config.before(:each, type: :system) do
    # リモートSeleniumの設定
    remote_url = ENV['CI'] ? 'http://localhost:4444/wd/hub' : 'http://selenium_chrome:4444/wd/hub'

    driven_by :selenium, using: :chrome, options: {
      browser: :remote,
      url: remote_url,
      capabilities: [
        Selenium::WebDriver::Chrome::Options.new.tap do |opts|
          opts.add_argument('--headless')
          opts.add_argument('--no-sandbox')
          opts.add_argument('--disable-dev-shm-usage')
        end
      ]
    }

    # サーバー設定
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4000
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  # リトライロジック（シンプル化）
  config.around(:each, type: :system) do |example|
    retry_count = 0
    begin
      example.run
    rescue => e
      retry_count += 1
      retry if retry_count <= 3 && (e.is_a?(Socket::ResolutionError) || e.message.include?('TCP connection'))
      raise e
    end
  end
end
