class Attendance < ApplicationRecord
  belongs_to :user

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
end
