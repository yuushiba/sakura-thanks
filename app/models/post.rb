class Post < ApplicationRecord
  has_one_attached :image

  def display_image
    return unless image.attached?

    # デバッグログを追加
    Rails.logger.debug "Processing image transformation..."
    
    # シンプルなリサイズから始める
    image.variant(resize_to_limit: [800, 800])
  end
end
