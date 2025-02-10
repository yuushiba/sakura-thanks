# app/models/post.rb
class Post < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many :comments, dependent: :destroy
  # has_many :favorites, dependent: :destroy
  # Active Storageの関連付けを追加
  has_one_attached :image 
   # プレビュー用のメソッド
   def image_with_text
    return image unless image.attached? && overlay_text.present?

    # Rails 7.2 の書き方に合わせて修正
  image.variant(resize_to_limit: [800, 800]) do |builder|
    builder.draw("text #{text_x_position},#{text_y_position} '#{overlay_text}'")
    builder.font("/rails/app/assets/fonts/Yomogi-Regular.ttf")
    builder.fill("white")
    builder.pointsize(24)
  end
  end
  
  # 属性名を日本語化
  def self.human_attribute_name(attr, options = {})
    {
      title: "タイトル",
      content: "内容"
    }[attr.to_sym] || super
  end

  validates :title, presence: { message: "を入力してください" }
  validates :content, presence: { message: "を入力してください" }

  # 画像のチェック（画像がある場合のみ実行）
  validate :validate_image, if: :image_attached?

  # 画像表示用のメソッド
  def display_image
    image.attached? ? image : "Cropped_Image copy.png"
  end

  # 新しいカラムのバリデーション
  validates :text_x_position, numericality: { only_integer: true }, allow_nil: true
  validates :text_y_position, numericality: { only_integer: true }, allow_nil: true
  validates :overlay_text, length: { maximum: 50 }  

  private

  def image_attached?
    image.attached?
  end

  # 画像の詳しいチェックを行うメソッド
  def validate_image
    return unless image.attached?

    # ファイルサイズのチェック（10MB以下）
    if image.blob.byte_size > 10.megabytes
      errors.add(:image, "は10MB以下にしてください")
      image.purge  # 大きすぎる画像を削除
    end

    unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:image, "はJPEG、JPG、PNG、GIF形式でアップロードしてください")
      image.purge # 不適切な画像を削除
    end
  end
end
