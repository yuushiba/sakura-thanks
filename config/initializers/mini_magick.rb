require 'mini_magick'

# ImageMagickのパスを設定
MiniMagick.configure do |config|
  config.cli = :imagemagick
  config.validate_on_create = false
end
