class SessionsController < ApplicationController
  def new
    # ユーザーがログインしているかチェック
    return unless logged_in?

    # ログイン済みであれば、current_userのshowページにリダイレクト
    redirect_to current_user
  end

  def create
    user = User.find_by(mail: params[:session][:mail].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user, success: 'ログインしました！'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other, success: 'ログアウトしました'
  end
end
