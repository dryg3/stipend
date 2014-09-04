class NewCreatePayToMonthStudents < ActiveRecord::Migration
  def change
    change_table :student_groups do |t|
      t.remove :type
      t.boolean :type      
    end
  end
end
