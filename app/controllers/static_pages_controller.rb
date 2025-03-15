class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top form terms privacy]
  def top; end
  def form; end
  def terms; end  # 利用規約表示用
  def privacy; end  # プライバシーポリシー表示用
end
