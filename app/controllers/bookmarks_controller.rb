class BookmarksController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.bookmark(@post)

    respond_to do |format|
      format.html { 
        flash[:success] = "投稿をブックマークしました"
        redirect_back(fallback_location: posts_path) 
      }
      format.turbo_stream { 
        flash.now[:success] = "投稿をブックマークしました"
        render turbo_stream: turbo_stream.replace("bookmark_btn_#{@post.id}", 
          partial: 'application/bookmark_button', locals: { post: @post }) 
      }
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @post = @bookmark.post
    current_user.unbookmark(@post)

    respond_to do |format|
      format.html { 
        flash[:success] = "ブックマークを削除しました"
        redirect_back(fallback_location: posts_path, status: :see_other) 
      }
      format.turbo_stream { 
        flash.now[:success] = "ブックマークを削除しました"
        render turbo_stream: turbo_stream.replace("bookmark_btn_#{@post.id}", 
          partial: 'application/bookmark_button', locals: { post: @post }) 
      }
    end
  end
end
