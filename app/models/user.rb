class User < ApplicationRecord
  # 小文字に自動変換
  before_save { self.mail = mail.downcase }

  #メールのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :mail, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  
  # パスワードのバリデーション
  has_secure_password
  validates :password, presence: true,
                      length: { minimum: 6 }

end
