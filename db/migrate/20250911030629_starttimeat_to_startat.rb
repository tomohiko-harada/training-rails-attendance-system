class StarttimeatToStartat < ActiveRecord::Migration[7.0]
  def change
    rename_column :attendances, :start_time_at, :started_at
    rename_column :attendances, :finish_time_at, :finished_at
    rename_column :attendances, :start_rest_time_at, :started_rest_at
    rename_column :attendances, :finish_rest_time_at, :finished_rest_at
  end
end
