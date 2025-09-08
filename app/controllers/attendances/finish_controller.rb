class Attendances::FinishController < ApplicationController
  def create
    # 既にfinish_timeが記録されているか確認
    if prevent_double_punch(:finish_time, "本日の退勤はすでに記録されています。")
      return 
    end

    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)

    # 休憩開始を記録できるかチェック
    if @attendance && @attendance.current_status == '勤務中'
      @attendance.update(finish_time: Time.now)
      redirect_to user_path(current_user), notice: '退勤しました。お疲れ様でした！'
    else
      redirect_to user_path(current_user), alert: '現在、勤務終了できません。'
    end
  end
end
