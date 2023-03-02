class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.primary_key :userID
      t.string :name
      t.string :username
      t.string :password
      t.boolean :isadmin

      t.timestamps
    end
  end
end
