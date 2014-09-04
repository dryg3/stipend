class NoType2 < ActiveRecord::Migration
  def change
	change_table :student_groups do |t|
		t.remove :type_stipend
		t.integer :type_stipend
	end
  end
end
