class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy ]
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:show]
  before_action :require_same_user, only: [:show]

  # def index
  #   @users = User.all
  # end

  def show
    # 本日の勤怠レコードを取得
    @attendance = current_user.attendances.find_by(date: Time.current.to_date)
    # ステータス取得 (※ @attendanceが存在しない(1日のうち出勤ボタン押していない)場合は「退勤中」 )
    @current_status = @attendance.present? ? @attendance.current_status : '退勤中'
  end

  def new
    @user = User.new
  end

  # def edit
  # end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to user_url(@user), success: "新規ユーザー登録を行いました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def update
  #   if @user.update(user_params)
  #     redirect_to user_url(@user), notice: "ユーザーアカウントを編集しました。"
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   if @user.destroy
  #     redirect_to users_url, notice: "ユーザーアカウントを削除しました。", status: :see_other
  #   end
  # end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      if current_user != @user
      flash[:alert] = "こちらのページにはアクセスできません。"
      redirect_back_or_to(root_url, status: :see_other)
    end
end

    def user_params
      params.require(:user).permit(:mail, :password, :password_confirmation)
    end
end
