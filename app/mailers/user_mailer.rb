class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  default from: "from@example.com"

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: "パスワードリセット")
  end

  def test_email
    mail(
      to: Rails.application.credentials.dig(:production, :gmail, :username),
      subject: "テストメール - #{Rails.env}環境"
    ) do |format|
      format.text { render plain: "メール送信テスト成功！" }
      format.html { render html: "<h1>メール送信テスト成功！</h1>".html_safe }
    end
  end
end
