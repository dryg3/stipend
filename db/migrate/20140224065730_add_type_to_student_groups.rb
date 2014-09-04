class AddTypeToStudentGroups < ActiveRecord::Migration
  def change
	change_table :student_groups do |t|
      t.boolean :social
      t.boolean :academic
      t.boolean :study
      t.boolean :public
      t.boolean :scientific
      t.boolean :cultural
      t.boolean :sports
    end
  end
end
