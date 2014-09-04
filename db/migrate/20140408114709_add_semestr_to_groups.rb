class AddSemestrToGroups < ActiveRecord::Migration
  def change
	change_table :groups do |t|
		t.integer :semester
	end
	
	change_table :pay_category_to_semesters do |t|
		t.integer :sum
	end
  end
end
