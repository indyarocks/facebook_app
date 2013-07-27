class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.column :user_id,'bigint', :null => false
      t.string :username, :null => false
      t.string :name
      t.string :gender
      t.string :hometown
      t.string :location
      t.text :bio

      t.timestamps
    end

    add_index :user_details, :username, :unique => true, :name => "UNIQUE"
  end
end
