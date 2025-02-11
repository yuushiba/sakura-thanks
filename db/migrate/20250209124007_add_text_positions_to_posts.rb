class AddTextPositionsToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :overlay_text, :string      # 画像に重ねる文字列
    add_column :posts, :text_x_position, :integer, default: 0  # 文字のx座標
    add_column :posts, :text_y_position, :integer, default: 0  # 文字のy座標
  end
end
