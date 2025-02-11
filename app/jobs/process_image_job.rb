class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    return unless post&.image&.attached? && post.overlay_text.present?

    # 画像処理を実行
    post.image_with_text.processed
  end
end
