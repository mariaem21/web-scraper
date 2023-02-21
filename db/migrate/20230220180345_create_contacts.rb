# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.integer :personID
      t.integer :orgID
      t.date :year
      t.string :name
      t.string :email
      t.string :officerposition
      t.string :description

      t.timestamps
    end
  end
end
