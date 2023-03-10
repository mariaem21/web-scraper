class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, id: false do |t|
      t.primary_key :organization_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
