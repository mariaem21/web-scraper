# frozen_string_literal: true

class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.integer :applicationID
      t.integer :orgID
      t.string :name
      t.date :datebuilt
      t.string :githublink
      t.string :description

      t.timestamps
    end
  end
end
