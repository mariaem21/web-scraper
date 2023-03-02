class CreateAppcats < ActiveRecord::Migration[7.0]
  def change
    create_table :appcats, id: false do |t|
      t.primary_key :appcatID
      t.integer :categoryID
      t.integer :applicationID

      t.timestamps
    end
  end
end
