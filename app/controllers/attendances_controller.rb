class AttendancesController < ApplicationController
  def index
    # パラメーターから年と月を取得し、ない場合は現在の日付を使用
    year = params[:year].present? ? params[:year].to_i : Time.current.year
    month = params[:month].present? ? params[:month].to_i : Time.current.month

    # 選択した月の最初の日付と最後の日付を設定
    @first_day = Date.new(year, month, 1)
    @last_day = @first_day.end_of_month

    # 選択した月の全日分の勤怠データを取得
    # user_id と date をスコープにしてデータを効率的に取得
    @attendances = current_user.attendances.where(date: @first_day..@last_day).order(date: :asc)

    # カレンダー表示用の配列を生成
    # @attendances_hash = {日付 => Attendanceオブジェクト} の形式に変換
    @attendances_hash = @attendances.index_by(&:date)
    @days_in_month = (@first_day..@last_day).to_a
    @calendar_data = @days_in_month.map do |day|
      @attendances_hash[day] || Attendance.new(date: day) # データがない日は新しいAttendanceインスタンスを作成
    end
  end

  def create
    # 既にstart_timeが記録されているか確認
    return if prevent_double_punch(:start_time, '本日の出勤はすでに記録されています。')

    @attendance = current_user.attendances.find_or_initialize_by(date: Time.current.to_date)
    # 新規作成したレコードにstart_timeをセット
    @attendance.start_time = Time.current

    if @attendance.save
      flash[:success] = '出勤時間を記録しました。'
      redirect_to user_path(current_user)
    else
      flash[:danger] = '出勤時間の記録に失敗しました。'
      redirect_to user_path(current_user)
    end
  end
end
