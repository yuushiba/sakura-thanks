class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  add_flash_types :success, :info, :warning, :danger
  # before_action :require_login

  private

  def not_authenticated
    flash[:warning] = "ログインしてください"
    redirect_to login_path
  end
end
