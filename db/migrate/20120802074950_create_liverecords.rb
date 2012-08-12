class CreateLiverecords < ActiveRecord::Migration
  def change
    create_table :liverecords do |t|
      t.integer :user_id
      t.integer :type_id
      t.integer :task_id
      t.datetime :start
      t.datetime :end
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
