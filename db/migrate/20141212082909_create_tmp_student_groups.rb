class CreateTmpStudentGroups < ActiveRecord::Migration
  def change
    create_table :tmp_student_groups do |t|
      t.boolean  :commerce
      t.integer  :student_id
      t.integer  :group_id
      t.integer  :type_stipend
      t.integer  :status
      t.integer  :user_id
      t.integer  :student_group_id
    end
  end
end
