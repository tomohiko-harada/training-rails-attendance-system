class Rests::FinishController < ApplicationController
  def create
    # 既にfinish_rest_timeが記録されているか確認
    if prevent_double_punch(:finish_rest_time, "本日の休憩終了時間はすでに記録されています。")
      return 
    end

    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)

    # 既にfinish_rest_timeが記録されているか確認
    prevent_double_punch(:finish_rest_time, "本日の休憩終了時間はすでに記録されています。")

    # 休憩開始を記録できるかチェック
    if @attendance && @attendance.current_status == '休憩中'
      @attendance.update(finish_rest_time: Time.now)
      redirect_to user_path(current_user), notice: '休憩を終了しました。'
    else
      redirect_to user_path(current_user), alert: '現在、休憩を終了できません。'
    end
  end
end
