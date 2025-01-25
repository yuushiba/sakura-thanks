class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

def create
  @post = current_user.posts.build(post_params)

  if @post.save
    redirect_to mypage_path, success: '投稿を作成しました'
  else
    render :new, status: :unprocessable_entity
  end
end

private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end
end
