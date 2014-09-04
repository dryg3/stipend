class CreateStudentGroups < ActiveRecord::Migration
  def change
    create_table :student_groups do |t|
      t.string :type_stipend
      t.boolean :refund
      t.boolean :commerce
      t.string :group
      t.references :student, index: true

      t.timestamps
    end
  end
end
