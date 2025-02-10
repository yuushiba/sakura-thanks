def create
  @post = current_user.posts.build(post_params)

  if @post.save
    # デバッグログを追加
    Rails.logger.debug "Post created successfully"
    Rails.logger.debug "Image attached: #{@post.image.attached?}"
    
    redirect_to mypage_path, success: "投稿を作成しました"
  else
    flash.now[:danger] = "投稿の作成に失敗しました"
    render :new, status: :unprocessable_entity
  end
end
