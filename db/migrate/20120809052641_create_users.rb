class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.integer :default_norm
      t.integer :is_verified
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
