# app/models/post.rb
class Post < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  # Active Storageの関連付けを追加
  has_one_attached :image

  # variant定義を追加
  def preview_with_text
    return image unless image.attached? && overlay_text.present?

    adjusted_x = text_x_position
    adjusted_y = text_y_position

    # デバッグログ
    Rails.logger.debug "Using position: (#{adjusted_x}, #{adjusted_y})"

    image.variant(
      resize_to_limit: [ 800, 800 ],
      font: "/usr/share/fonts/truetype/custom/Yomogi-Regular.ttf",
      fill: "white",
      pointsize: "64",
      gravity: "northwest",
      draw: [
        # 影
        "fill rgba(0,0,0,0.5) text #{adjusted_x + 2},#{adjusted_y + 2} '#{overlay_text}'",
        # メインテキスト
        "fill white text #{adjusted_x},#{adjusted_y} '#{overlay_text}'"
      ].join(" ")
    )
  end

  # 表示用のメソッドも同様に修正
  def image_with_text
    preview_with_text
  end

  validates :title, presence: true
  validates :content, presence: true

  # 画像のチェック（画像がある場合のみ実行）
  validate :validate_image, if: :image_attached?

  # 画像表示用のメソッド
  def display_image
    image.attached? ? image : "Cropped_Image copy.png"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "content", "created_at", "id", "user_id", "overlay_text" ]
  end

  # 新しいカラムのバリデーション
  validates :text_x_position, numericality: { only_integer: true }, allow_nil: true
  validates :text_y_position, numericality: { only_integer: true }, allow_nil: true
  validates :overlay_text, length: { maximum: 20 }

  private

  def image_attached?
    image.attached?
  end

  # 画像の詳しいチェックを行うメソッド
  def validate_image
    return unless image.attached?

    # ファイルサイズのチェック（10MB以下）
    if image.blob.byte_size > 10.megabytes
      errors.add(:image, :too_large, count: 10)
      image.purge  # 大きすぎる画像を削除
    end

    unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:image, :invalid_format)
      image.purge # 不適切な画像を削除
    end
  end
end
