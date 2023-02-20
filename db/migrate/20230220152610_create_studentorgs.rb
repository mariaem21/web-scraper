class CreateStudentorgs < ActiveRecord::Migration[7.0]
  def change
    create_table :studentorgs do |t|
      t.string :name
      t.string :email
      t.string :fullname

      t.timestamps
    end
  end
end
