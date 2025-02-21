class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  authenticates_with_sorcery! do |config|
  config.reset_password_mailer = UserMailer
  config.authentications_class = Authentication
  end

  # パスワードのバリデーションを一つにまとめ、Google認証の場合は除外
  validates :password, length: { minimum: 3 },
            if: -> { new_record? && authentications.empty? }
  validates :password, confirmation: true,
            if: -> { new_record? && authentications.empty? }
  validates :password_confirmation, presence: true,
            if: -> { new_record? && authentications.empty? }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  # パスワードリセット用のバリデーションを追加
  validates :reset_password_token, uniqueness: true, allow_nil: true
end
