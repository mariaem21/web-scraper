# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :userID
      t.string :name
      t.string :username
      t.string :password
      t.boolean :isadmin

      t.timestamps
    end
  end
end
