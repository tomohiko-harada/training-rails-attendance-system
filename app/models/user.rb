class User < ApplicationRecord
  # メールの文字数上限

  has_many :attendances, dependent: :destroy

  # 小文字に自動変換
  before_save { self.mail = mail.downcase }

  # メールのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAIL_MAX_CHAR = 105
  validates :mail, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: MAIL_MAX_CHAR },
                   format: { with: VALID_EMAIL_REGEX }

  # パスワードのバリデーション
  has_secure_password
  validates :password, presence: true,
                       length: { minimum: 6 }
end
