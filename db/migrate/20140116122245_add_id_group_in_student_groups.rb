class AddIdGroupInStudentGroups < ActiveRecord::Migration
  def change
    change_table :student_groups do |t|
      t.remove :group
      t.references :group, index: true
    end
  end
end
