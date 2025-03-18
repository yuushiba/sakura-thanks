require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名前、メール、パスワードがあれば有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前がなければ無効であること' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'メールアドレスがなければ無効であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it '重複したメールアドレスなら無効であること' do
      create(:user, email: 'duplicate@example.com')
      user = build(:user, email: 'duplicate@example.com')
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
    end

    context 'Google認証なしの場合' do
      it 'パスワードが3文字未満なら無効であること' do
        user = build(:user, password: 'ab', password_confirmation: 'ab')
        user.valid?
        expect(user.errors[:password]).to include('は3文字以上で入力してください')
      end

      it 'パスワード確認が一致しなければ無効であること' do
        user = build(:user, password: 'password', password_confirmation: 'different')
        user.valid?
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end
  end

  describe '関連付け' do
    it '複数の投稿を持つこと' do
      user = create(:user)
      create_list(:post, 3, user: user)
      expect(user.posts.count).to eq 3
    end

    it 'ユーザーが削除されると、関連する投稿も削除されること' do
      user = create(:user)
      create(:post, user: user)

      expect { user.destroy }.to change { Post.count }.by(-1)
    end
  end

  describe 'ブックマーク機能' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it '投稿をブックマークできること' do
      expect { user.bookmark(post) }.to change { user.bookmarks.count }.by(1)
    end

    it 'ブックマークした投稿を取り消せること' do
      user.bookmark(post)
      expect { user.unbookmark(post) }.to change { user.bookmarks.count }.by(-1)
    end

    it '投稿がブックマークされているか確認できること' do
      expect(user.bookmark?(post)).to be_falsey
      user.bookmark(post)
      expect(user.bookmark?(post)).to be_truthy
    end
  end
end
