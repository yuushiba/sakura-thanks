namespace :mailer do
  desc "メール設定のテスト"
  task test: :environment do
    puts "テストメールを送信します..."
    begin
      UserMailer.test_email.deliver_now
      puts "成功：メールが送信されました！"
    rescue => e
      puts "エラー：#{e.message}"
    end
  end
end
