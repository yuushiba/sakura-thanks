# app/controllers/oauths_controller.rb
class OauthsController < ApplicationController
  skip_before_action :require_login, only: %i[oauth callback]

  def oauth
    provider = auth_params[:provider]
    redirect_to sorcery_login_url(provider), allow_other_host: true
  end

  def callback
    provider = auth_params[:provider]
    begin
      if (@user = login_from(provider))
        redirect_to root_path, success: "Googleでログインしました"
      else
        handle_new_user(provider)
      end
    rescue StandardError => e
      handle_error(e, provider)
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :scope, :authuser, :prompt)
  end

  def handle_new_user(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
    redirect_to root_path, success: "Googleでログインしました"
  end

  def handle_error(error, provider)
    Rails.logger.error "OAuth Error: #{error.message}"
    redirect_to root_path, danger: "#{provider.titleize}でのログインに失敗しました"
  end
end
