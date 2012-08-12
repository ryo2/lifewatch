class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :importance
      t.integer :estimated_duration
      t.datetime :dead_line
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
