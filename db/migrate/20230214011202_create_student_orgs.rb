class CreateStudentOrgs < ActiveRecord::Migration[7.0]
  def change
    create_table :student_orgs do |t|
      t.string :name
      t.string :email
      t.string :full_name

      t.timestamps
    end
  end
end
