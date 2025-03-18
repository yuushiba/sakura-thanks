require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it 'タイトル、内容、ユーザーがあれば有効であること' do
      post = build(:post)
      expect(post).to be_valid
    end

    it 'タイトルがなければ無効であること' do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include('を入力してください')
    end

    it '内容がなければ無効であること' do
      post = build(:post, content: nil)
      post.valid?
      expect(post.errors[:content]).to include('を入力してください')
    end

    it 'オーバーレイテキストは20文字以内であること' do
      post = build(:post, overlay_text: 'a' * 21)
      post.valid?
      expect(post.errors[:overlay_text]).to include('は20文字以内で入力してください')
    end

    it 'テキスト位置X座標は整数であること' do
      post = build(:post, text_x_position: 'abc')
      post.valid?
      expect(post.errors[:text_x_position]).to include('は数値で入力してください')
    end

    it 'テキスト位置Y座標は整数であること' do
      post = build(:post, text_y_position: 'abc')
      post.valid?
      expect(post.errors[:text_y_position]).to include('は数値で入力してください')
    end
  end

  describe '関連付け' do
    it 'ユーザーに属していること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のコメントを持つこと' do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq :has_many
    end

    it '複数のブックマークを持つこと' do
      association = described_class.reflect_on_association(:bookmarks)
      expect(association.macro).to eq :has_many
    end
  end

  describe '画像メソッド' do
    context '画像がアタッチされている場合' do
      let(:post) { build(:post, :with_image) }

      it 'display_imageメソッドが画像を返すこと' do
        expect(post.display_image).to eq post.image
      end
      
      it 'image_with_textメソッドが画像バリアントを返すこと' do
        # 注: ここではメソッドが例外を投げないことだけを確認
        expect { post.image_with_text }.not_to raise_error
      end
    end

    context '画像がアタッチされていない場合' do
      let(:post) { build(:post) }

      it 'display_imageメソッドがデフォルト画像の名前を返すこと' do
        expect(post.display_image).to eq "Cropped_Image copy.png"
      end
    end
  end

  describe '検索機能' do
    it 'ransackable_attributesで検索可能な属性が定義されていること' do
      expected_attributes = [ "title", "content", "created_at", "id", "user_id", "overlay_text" ]
      expect(Post.ransackable_attributes).to match_array(expected_attributes)
    end
  end
end
