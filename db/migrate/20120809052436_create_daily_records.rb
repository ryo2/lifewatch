class CreateDailyRecords < ActiveRecord::Migration
  def change
    create_table :daily_records do |t|
      t.integer :user_id
      t.date :date
      t.integer :norm
      t.integer :type1
      t.integer :type2
      t.integer :type3
      t.integer :tyoe4
      t.integer :type5
      t.integer :type6
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
