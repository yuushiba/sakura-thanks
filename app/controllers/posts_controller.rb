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
        begin
          # バリアントを処理
          @post.preview_with_text.processed
        rescue => e
          Rails.logger.error "画像処理でエラーが発生: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")  # スタックトレースも記録
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
      if @post.overlay_text.present? && @post.image.attached?
        begin
          @post.preview_with_text.processed
        rescue => e
          Rails.logger.error "画像処理でエラーが発生: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
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
