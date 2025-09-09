class ApplicationController < ActionController::Base
  # 対応flashを増やす
  add_flash_types :success, :info, :warning, :danger
  # sessipn管理用のメソッド
  include SessionsHelper

  # あるユーザーが別ユーザーのページにアクセスした場合はブロックする
  def require_same_user
    # パラメータからユーザーIDを取得。idがあればidを、なければuser_idを使用する
    user_param_id = params[:id] || params[:user_id]
    @user = User.find(user_param_id)

    if current_user != @user
      flash[:danger] = 'こちらのページにはアクセスできません。'
      redirect_back_or_to(root_url, status: :see_other)
    end
  end

  private

  # 同じ打刻ボタンを1日に2度押されていたらtrueを返すメソッド
  def prevent_double_punch(field_name, flash_message)
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)

    if @attendance && @attendance.send(field_name).present?
      flash[:danger] = flash_message
      redirect_to user_path(current_user)
      return true # 処理を終了させることを呼び出し元に伝える
    end

    false # 処理を続行可能であることを呼び出し元に伝える
  end
end
