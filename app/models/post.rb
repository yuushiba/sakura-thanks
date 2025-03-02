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

  def debug_image_processing
    return { success: false, message: "No image or text" } unless image.attached? && overlay_text.present?

    begin
      variant = preview_with_text
      processed = variant.processed
      Rails.logger.info "画像処理成功: #{overlay_text}"
      { success: true, message: "画像処理成功", variant: variant }
    rescue => e
      Rails.logger.error "画像処理エラー: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      { success: false, message: e.message }
    end
  end

  def debug_font_path
    font_path = "/usr/share/fonts/truetype/custom/Yomogi-Regular.ttf"
    {
      exists: File.exist?(font_path),
      readable: File.readable?(font_path),
      path: font_path
    }
  end

  def debug_font_setup
    font_path = Rails.root.join("app/assets/fonts/Yomogi-Regular.ttf").to_s
    docker_font_path = "/usr/share/fonts/truetype/custom/Yomogi-Regular.ttf"

    {
      rails_root: Rails.root.to_s,
      app_font_exists: File.exist?(font_path),
      app_font_readable: File.readable?(font_path),
      docker_font_exists: File.exist?(docker_font_path),
      docker_font_readable: File.readable?(docker_font_path)
    }
  end
  def debug_font_info
    {
      available_fonts: `fc-list`.split("\n"),
      image_magick_fonts: `convert -list font`.split("\n"),
      current_font: "/usr/share/fonts/truetype/custom/Yomogi-Regular.ttf",
      font_exists: File.exist?("/usr/share/fonts/truetype/custom/Yomogi-Regular.ttf")
    }
  rescue => e
    { error: e.message }
  end

  def debug_image_dimensions
    return unless image.attached?

    variant = image.variant(resize_to_limit: [ 800, 800 ])
    metadata = variant.processed.metadata

    Rails.logger.debug "Image dimensions: #{metadata['width']}x#{metadata['height']}"
    Rails.logger.debug "Display dimensions: 800x800"
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
      errors.add(:image, "は10MB以下にしてください")
      image.purge  # 大きすぎる画像を削除
    end

    unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:image, "はJPEG、JPG、PNG、GIF形式でアップロードしてください")
      image.purge # 不適切な画像を削除
    end
  end
end
