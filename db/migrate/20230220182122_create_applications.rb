class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications, id: false do |t|
      t.primary_key :applicationID
      t.integer :orgID
      t.string :name
      t.date :datebuilt
      t.string :githublink
      t.string :description

      t.timestamps
    end
  end
end
