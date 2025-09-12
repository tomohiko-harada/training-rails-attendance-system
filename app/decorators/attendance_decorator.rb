# frozen_string_literal: true

module AttendanceDecorator
  
  def current_status
    if off_duty?
      '退勤'
    elsif on_break?
      '休憩中'
    elsif on_duty?
      '勤務中'
    else
      '不明'
    end
  end
end
