# app/models/post.rb
class Post < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image  # Active Storageの関連付けを追加

  validates :title, presence: { message: "を入力してください" }
  validates :content, presence: { message: "を入力してください" }
  # 画像の検証
  validate :acceptable_image, if: :image_attached?

  private

  # 画像が添付されているかをチェック
  def image_attached?
    image.attached?
  end

  def display_image
    image.attached? ? image : "Cropped_Image copy.png"
  end

  # 画像のバリデーションロジック
  def acceptable_image
    # ファイルサイズの検証（5MB以下）
    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end

    # ファイル形式の検証（jpg, jpeg, png, gifのみ許可）
    acceptable_types = [ "image/jpeg", "image/jpg", "image/png", "image/gif" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "はJPG、JPEG、PNG、GIF形式でアップロードしてください")
    end
  rescue
    # 画像の検証中にエラーが発生した場合
    errors.add(:image, "を処理できませんでした。ファイルを確認してください")
  end
end
