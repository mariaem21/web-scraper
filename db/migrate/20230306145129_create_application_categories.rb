class CreateApplicationCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :application_categories, id: false do |t|
      t.primary_key :application_category_id
      t.integer :application_id
      t.integer :category_id

      t.timestamps
    end
  end
end
