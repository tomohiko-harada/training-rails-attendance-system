class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.datetime :start_rest_time
      t.datetime :finish_rest_time

      t.timestamps
    end
  end
end
