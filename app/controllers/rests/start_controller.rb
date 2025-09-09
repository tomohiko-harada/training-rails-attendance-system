class Rests::StartController < ApplicationController
  before_action :require_user
  before_action :require_same_user
  
  def create
    # 既にstart_rest_timeが記録されているか確認
    return if prevent_double_punch(:start_rest_time, '本日の休憩開始時間はすでに記録されています。')

    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)

    # 休憩開始を記録できるかチェック
    if @attendance && @attendance.current_status == '勤務中'
      @attendance.update(start_rest_time: Time.now)
      redirect_to user_path(current_user), notice: '休憩を開始しました。'
    else
      redirect_to user_path(current_user), danger: '現在、休憩を開始できません。'
    end
  end
end
