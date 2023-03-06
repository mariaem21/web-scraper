class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, id: false do |t|
      t.primary_key :contact_id
      t.integer :organization_id
      t.date :year
      t.string :name
      t.string :email
      t.string :officer_position
      t.string :description

      t.timestamps
    end
  end
end
