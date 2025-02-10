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
    if @post.overlay_text.present? && @post.image.attached?
      # image_with_textメソッドを使用
      begin
        # variant生成を明示的に実行
        @post.image_with_text.processed
        Rails.logger.debug "Image processing completed successfully"
      rescue => e
        Rails.logger.error "Image processing error: #{e.message}\n#{e.backtrace.join("\n")}"
        # エラーが発生しても投稿自体は保存する
      end
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
