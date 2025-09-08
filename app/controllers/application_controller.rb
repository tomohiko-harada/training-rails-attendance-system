class ApplicationController < ActionController::Base
  # 対応flashを増やす
  add_flash_types :success, :info, :warning, :danger
  # sessipn管理用のメソッド
  include SessionsHelper

  private

  # 同じ打刻ボタンを1日に2度押されていたらtrueを返すメソッド
  def prevent_double_punch(field_name, flash_message)
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)
    
    if @attendance && @attendance.send(field_name).present?
      flash[:danger] = flash_message
      redirect_to user_path(current_user)
      return true # 処理を終了させることを呼び出し元に伝える
    end
    
    return false # 処理を続行可能であることを呼び出し元に伝える
  end
end
