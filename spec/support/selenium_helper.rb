require 'capybara/rspec'

# CI環境ではシステムテストをスキップする
RSpec.configure do |config|
  # CI環境ではシステムテストをスキップ
  # config.filter_run_excluding type: :system if ENV['CI']

  # 代わりに特定のテストだけを実行
  if ENV['CI']
  config.filter_run_including first_ci_system_test: true
  puts "🔍 CI環境では 'first_ci_system_test: true' のテストのみ実行します"
  end

  # 非CI環境でのシステムテスト設定
  config.before(:each, type: :system) do
    # CI環境とローカル環境で異なる設定
    if ENV['CI']
      driven_by :selenium, using: :chrome, options: {
        browser: :chrome,
        capabilities: [
          Selenium::WebDriver::Chrome::Options.new.tap do |opts|
            opts.add_argument('--headless')
            opts.add_argument('--no-sandbox')
            opts.add_argument('--disable-dev-shm-usage')
          end
        ]
      }
      puts "🌐 CI環境用のローカルChromeブラウザ設定を使用します"
    else
      # ローカル環境では以前と同じ設定
      remote_url = 'http://selenium_chrome:4444/wd/hub'

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
    end

    # サーバー設定（両環境共通）
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
