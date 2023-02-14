class DropStudentOrgs < ActiveRecord::Migration[7.0]
  def change
    drop_table :student_orgs
  end
end
