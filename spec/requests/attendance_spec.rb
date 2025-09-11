require 'rails_helper'

RSpec.describe "Attendances", type: :request do
  # 共通で使うユーザーインスタンスを定義
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:date_on) { Time.zone.today }

  # ヘルパーメソッド（ここではログイン処理を共通化）
  def login_as(user)
    post login_path, params: { session: { mail: user.mail, password: 'password' } }
  end

  # --- 認証と認可のテスト ---
  describe "GET /users/:user_id/attendances" do
    # 認証系のテストには特定のbeforeブロックは不要。
    # なぜなら、各テストケースの内部でログイン状況を制御しているため。
    context "ログインしていない場合" do
      it "ログインページにリダイレクトすること" do
        get user_attendances_path(user)
        expect(response).to redirect_to(login_path)
      end
    end

    context "他のユーザーとしてログインしている場合" do
      before do
        # このコンテキストのテスト開始前にログイン処理を実行
        login_as(other_user)
      end

      it "root URLにリダイレクトすること" do
        get user_attendances_path(user)
        expect(response).to redirect_to(root_url)
      end
    end
    # ... (その他の認証テスト)
  end

  # --- 打刻順序のテスト ---
  describe "POST /users/:user_id/attendances" do
    # このdescribeブロック内の全テストで共通のログイン処理
    before do
      login_as(user)
    end

    context "出勤ボタンを2回連続で押した場合" do
      # このテストケース専用のデータセットアップ
      before do
        FactoryBot.create(:attendance, user: user, date_on: date_on, started_at: Time.current, finished_at: nil, started_rest_at: nil, finished_rest_at: nil)
      end

      it "出勤時間の重複エラーが表示されること" do
        post user_attendances_path(user), params: { attendance: { date_on: date_on, started_at: Time.current } }
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("本日の出勤はすでに記録されています。")
      end
    end
  end
  
  describe "POST /attendances/finish" do
    # このdescribeブロック内の全テストで共通のログイン処理
    before do
      login_as(user)
    end

    context "出勤記録がない状態で退勤ボタンを押した場合" do

      it "退勤できない旨のエラーが表示されること" do
        post attendances_finish_path
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("現在、退勤できません。")
      end
    end

    context "出勤記録がある状態で退勤ボタンを押した場合" do
      # このテストケース専用のデータセットアップ
      before do
        FactoryBot.create(:attendance, user: user, date_on: date_on, started_at: Time.current, finished_at: nil, started_rest_at: nil, finished_rest_at: nil)
      end

      it "退勤時間が記録され、成功メッセージが表示されること" do
        post attendances_finish_path
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("退勤しました。お疲れ様でした！")
        expect(user.attendances.find_by(date_on: date_on).finished_at).not_to be_nil
      end
    end
  end

  # ... (その他のテスト)
end
