class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: false do |t|
      t.primary_key :category_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
