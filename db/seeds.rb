# 1. Userの作成
puts 'ユーザーを作成中...'
user = User.find_or_create_by!(mail: 'test@jmty.jp') do |u|
  u.password = 'password'
end
puts "ユーザー: #{user.mail} が作成されました。"

# 2. 本日より40日前〜1日前の平日のAttendanceデータを作成
puts '勤怠データを生成中...'

# 40日前から昨日までの日付範囲
(40.days.ago.to_date..Date.yesterday).each do |date|
  # 平日（月曜日=1, 金曜日=5）のみ処理
  next unless date.on_weekday?

  # 出勤時間と退勤時間のランダムな値を設定
  start_time = Time.zone.local(date.year, date.month, date.day, 9, rand(0..30))
  finish_time = Time.zone.local(date.year, date.month, date.day, 18, rand(30..59))

  # 休憩時間を作成するかを1/2の確率で決定
  has_rest = [true, false].sample

  if has_rest
    # 休憩時間をランダムな値で設定
    start_rest_time = Time.zone.local(date.year, date.month, date.day, 12, rand(0..10))
    finish_rest_time = Time.zone.local(date.year, date.month, date.day, 12, rand(50..59))
  else
    # 休憩時間データはnil
    start_rest_time = nil
    finish_rest_time = nil
  end

  # Attendanceレコードを作成
  attendance = user.attendances.find_or_initialize_by(date_on: date)
  attendance.start_time_at = start_time
  attendance.finish_time_at = finish_time
  attendance.start_rest_time_at = start_rest_time
  attendance.finish_rest_time_at = finish_rest_time

  # 保存
  attendance.save!
end

puts '勤怠データの生成が完了しました。'
