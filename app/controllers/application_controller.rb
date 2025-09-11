class ApplicationController < ActionController::Base
  # 対応flashを増やす
  add_flash_types :success, :info, :warning, :danger
  # sessipn管理用のメソッド
  include SessionsHelper

  # ログインしていないユーザーがアクセスしてきた場合、ログイン画面にリダイレクトさせる
  def require_user
    return if logged_in?

    flash[:danger] = 'ログインしてください。'
    redirect_to login_path
  end

  # あるユーザーが別ユーザーのページにアクセスした場合はブロックする
  def require_same_user
    accessed_user = User.find_by(id: params[:user_id])

    # ユーザーが見つからない、または現在のユーザーと一致しない場合にアクセスをブロック
    return unless accessed_user.nil? || current_user != accessed_user

    flash[:danger] = 'こちらのページにはアクセスできません。'
    redirect_to root_url, status: :see_other
  end

  private

  # 同じ打刻ボタンを1日に2度押されていたらtrueを返すメソッド
  def prevent_double_punch(field_name, flash_message)
    # 許可リストを定義
    allowed_fields = %i[started_at finished_at started_rest_at finished_rest_at]

    # パラメーターが許可リストに含まれているかチェック
    unless allowed_fields.include?(field_name)
      # 許可されていないフィールド名が渡された場合、エラーを返す
      raise ArgumentError, "Invalid field name: #{field_name}"
    end

    attendance = current_user.attendances.find_by(date_on: Time.current.to_date)

    if attendance && attendance.public_send(field_name).present?
      flash[:danger] = flash_message
      redirect_to user_path(current_user)
      return true # 処理を終了させることを呼び出し元に伝える
    end

    false # 処理を続行可能であることを呼び出し元に伝える
  end
end
