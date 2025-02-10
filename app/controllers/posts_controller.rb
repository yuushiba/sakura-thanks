class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

def create
  @post = current_user.posts.build(post_params)

  if @post.save
    begin
      # 画像とテキストがある場合だけ処理する
      if @post.overlay_text.present? && @post.image.attached?
        @post.preview_with_text&.processed
      end
    rescue => e
      # エラーが起きても投稿自体は保存されるようにする
      Rails.logger.error "画像処理でエラーが発生: #{e.message}"
    end
    redirect_to mypage_path, success: "投稿を作成しました"
  else
    flash.now[:danger] = "投稿の作成に失敗しました"
    render :new, status: :unprocessable_entity
  end
end

def show
  @post = Post.find(params[:id])
  @comment = Comment.new
  @comments = @post.comments.includes(:user).order(created_at: :asc)
end

def edit
  @post = current_user.posts.find(params[:id])
end

def update
  @post = current_user.posts.find(params[:id])
  if @post.update(post_params)
    # 更新時もテキストがある場合は画像を再処理
    if @post.overlay_text.present?
      @post.image.variant(:with_text).processed
    end
    redirect_to post_path(@post), success: "投稿を更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @post = current_user.posts.find(params[:id])
  @post.destroy!
  redirect_to mypage_path
rescue ActiveRecord::RecordNotFound
  redirect_to mypage_path
end

private

  def post_params
    params.require(:post).permit(
    :title, 
    :content, 
    :image, 
    :overlay_text,
    :text_x_position,
    :text_y_position)
  end
end
