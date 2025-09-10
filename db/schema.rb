# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_250_910_094_119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'attendances', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.date 'date_on'
    t.datetime 'start_time_at'
    t.datetime 'finish_time_at'
    t.datetime 'start_rest_time_at'
    t.datetime 'finish_rest_time_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[user_id date_on], name: 'index_attendances_on_user_and_date', comment: '個人の勤続年数に関係なく一定の高速性を保証'
    t.index ['user_id'], name: 'index_attendances_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'mail'
    t.string 'password_digest'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['mail'], name: 'index_users_on_mail', unique: true, comment: 'ログイン時のユーザー検索高速化'
  end

  add_foreign_key 'attendances', 'users'
end
