class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications, id: false do |t|
      t.primary_key :application_id
      t.integer :contact_organization_id
      t.string :name
      t.date :date_built
      t.string :github_link
      t.string :description

      t.timestamps
    end
  end
end
