class AddCriticalIndexes < ActiveRecord::Migration[7.0]
  def change
    # 勤怠データ検索の高速化
    add_index :attendances, [:user_id, :date_on],
              name: 'index_attendances_on_user_and_date',
              comment: '個人の勤続年数に関係なく一定の高速性を保証'

    # ログイン処理の高速化
    add_index :users, :mail,
              unique: true,
              name: 'index_users_on_mail',
              comment: 'ログイン時のユーザー検索高速化'
  end
end
