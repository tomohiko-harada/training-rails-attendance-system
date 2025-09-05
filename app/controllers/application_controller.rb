class ApplicationController < ActionController::Base
  # 対応flashを増やす
  add_flash_types :success, :info, :warning, :danger
  # sessipn管理用のメソッド
  include SessionsHelper
end
