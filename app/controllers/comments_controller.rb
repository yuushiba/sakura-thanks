class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to post_path(@comment.post)
    else
      flash[:error] = "コメントの投稿に失敗しました"
      redirect_to post_path(@comment.post)
    end
  end

  def edit
    @post = @comment.post
  end

  def update
    if @comment.update(comment_params)
      flash[:success] = "コメントを更新しました"
      redirect_to post_path(@comment.post)
    else
      flash[:error] = "コメントの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    post = @comment.post
    @comment.destroy!
    flash[:success] = "コメントを削除しました"
    redirect_to post_path(post)
  end

  private
  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
