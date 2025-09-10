class Rests::FinishController < ApplicationController
  before_action :require_user
  before_action :require_same_user

  def create
    # 既にfinish_rest_timeが記録されているか確認
    return if prevent_double_punch(:finish_rest_time_at, '本日の休憩終了時間はすでに記録されています。')

    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date_on: Time.current.to_date)

    # 休憩開始を記録できるかチェック
    if @attendance && @attendance.current_status == '休憩中'
      @attendance.update(finish_rest_time_at: Time.now)
      redirect_to user_path(current_user), success: '休憩を終了しました。'
    else
      redirect_to user_path(current_user), danger: '現在、休憩を終了できません。'
    end
  end
end
