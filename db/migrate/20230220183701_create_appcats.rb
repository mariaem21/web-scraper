# frozen_string_literal: true

class CreateAppcats < ActiveRecord::Migration[7.0]
  def change
    create_table :appcats do |t|
      t.integer :appcatID
      t.integer :categoryID
      t.integer :applicationID

      t.timestamps
    end
  end
end
