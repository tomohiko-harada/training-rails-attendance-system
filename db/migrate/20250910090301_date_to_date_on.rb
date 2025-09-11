class DateToDateOn < ActiveRecord::Migration[7.0]
  def change
    rename_column :attendances, :date, :date_on
    rename_column :attendances, :start_time, :start_time_at
    rename_column :attendances, :finish_time, :finish_time_at
    rename_column :attendances, :start_rest_time, :start_rest_time_at
    rename_column :attendances, :finish_rest_time, :finish_rest_time_at
  end
end
