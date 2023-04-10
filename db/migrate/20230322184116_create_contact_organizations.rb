class CreateContactOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_organizations, id: false do |t|
      t.primary_key :contact_organization_id
      t.integer :contact_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
