class Attendance < ApplicationRecord
  belongs_to :user

  # 日付とユーザーの組み合わせはユニークであること
  validates :date, uniqueness: { scope: :user_id, message: "は1日に1回しか登録できません。" }

  # イベントの順序を検証するカスタムバリデーション
  validate :validate_event_order

  # 現在のステータスを判定するメソッド
  def current_status
    if start_time.nil? || (start_time.present? && finish_time.present?)
      '退勤'
    elsif start_rest_time.present? && finish_rest_time.nil?
      '休憩中'
    elsif start_time.present? && finish_time.nil?
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
    if finish_time.present?
      errors.add(:finish_time, 'は出勤時間より後に設定してください。') unless start_time.present? && finish_time > start_time
    end

    # 休憩開始時間が存在する場合、出勤時間は必須
    if start_rest_time.present?
      errors.add(:start_rest_time, 'は出勤時間より後に設定してください。') unless start_time.present? && start_rest_time > start_time
    end

    # 休憩終了時間が存在する場合、休憩開始時間は必須
    if finish_rest_time.present?
      errors.add(:finish_rest_time, 'は休憩開始時間より後に設定してください。') unless start_rest_time.present? && finish_rest_time > start_rest_time
    end

    # 休憩時間が勤務時間内にあることを確認
    if start_rest_time.present? && finish_rest_time.present?
      unless start_time.present? && finish_time.present? && start_rest_time >= start_time && finish_rest_time <= finish_time
        errors.add(:base, '休憩時間は勤務時間内に収める必要があります。')
      end
    end
  end

end
