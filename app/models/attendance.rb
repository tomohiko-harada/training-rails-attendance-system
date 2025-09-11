class Attendance < ApplicationRecord
  belongs_to :user

  # 日付とユーザーの組み合わせはユニークであること
  validates :date_on, uniqueness: { scope: :user_id, message: 'は1日に1回しか登録できません。' }

  # イベントの順序を検証するカスタムバリデーション
  validate :validate_event_order

  # 現在のステータスを判定するメソッド
  def current_status
    if started_at.nil? || (started_at.present? && finished_at.present?)
      '退勤'
    elsif started_rest_at.present? && finished_rest_at.nil?
      '休憩中'
    elsif started_at.present? && finished_at.nil?
      '勤務中'
    else
      # その他の想定外の状態
      '不明'
    end
  end

  private

  # イベントの順序と論理的な矛盾をチェックするメソッド
  def validate_event_order
    # 退勤時間が存在する場合、出勤時間は必須
    if finished_at.present? && (started_at.nil? || finished_at <= started_at)
      errors.add(:finished_at, 'は出勤時間より後に設定してください。')
    end

    # 休憩開始時間が存在する場合、出勤時間は必須
    if started_rest_at.present? && (started_at.nil? || started_rest_at <= started_at)
      errors.add(:started_rest_at, 'は出勤時間より後に設定してください。')
    end

    # 休憩終了時間が存在する場合、休憩開始時間は必須
    if finished_rest_at.present? && (started_rest_at.nil? || finished_rest_at <= started_rest_at)
      errors.add(:finished_rest_at, 'は休憩開始時間より後に設定してください。')
    end

    # 休憩時間が勤務時間内にあることを確認
    return unless started_rest_at.present? && finished_rest_at.present? && finished_at.present?
    return unless started_at.nil? || started_rest_at < started_at || finished_rest_at > finished_at

    errors.add(:base, '休憩時間は勤務時間内に収める必要があります。')
  end
end
