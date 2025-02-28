class BookmarksController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.bookmark(@post)
    
    # 通知メッセージだけを追加
    flash[:success] = "投稿をブックマークしました"
    
    # リダイレクト
    redirect_back(fallback_location: posts_path)
  end
  
  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    post = @bookmark.post
    current_user.unbookmark(post)
    
    flash[:success] = "ブックマークを削除しました"
    # status: :see_other を外し、redirect_backにオプションとして渡す
    redirect_back fallback_location: posts_path, status: :see_other
  end
end
