class Attendances::FinishController < ApplicationController
  before_action :require_user
  before_action :require_same_user

  def create
    # 既にfinish_timeが記録されているか確認
    return if prevent_double_punch(:finished_at, '本日の退勤はすでに記録されています。')

    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date_on: Time.current.to_date)

    # 休憩開始を記録できるかチェック
    if @attendance && @attendance.on_duty?
      @attendance.update(finished_at: Time.now)
      redirect_to user_path(current_user), success: '退勤しました。お疲れ様でした！'
    else
      redirect_to user_path(current_user), danger: '現在、勤務終了できません。'
    end
  end
end
