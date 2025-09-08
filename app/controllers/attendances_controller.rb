class AttendancesController < ApplicationController
  def index
    
  end

  def create
    # 既にstart_timeが記録されているか確認
    if prevent_double_punch(:start_time, "本日の出勤はすでに記録されています。")
      return 
    end
    
    @attendance = current_user.attendances.find_or_initialize_by(date: Time.current.to_date)
    # 新規作成したレコードにstart_timeをセット
    @attendance.start_time = Time.current

    if @attendance.save
      flash[:success] = "出勤時間を記録しました。"
      redirect_to user_path(current_user)
    else
      flash[:danger] = "出勤時間の記録に失敗しました。"
      redirect_to user_path(current_user)
    end

  end
end
