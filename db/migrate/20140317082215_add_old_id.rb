class AddOldId < ActiveRecord::Migration
  def change
	change_table :students do |t|
		t.integer :old_id
	end
	change_table :groups do |t|
		t.string :year
		t.references :faculty, index: true
		t.integer :old_id
	end
	change_table :student_groups do |t|
		t.integer :old_id
	end
	change_table :faculties do |t|	
		t.integer :old_id
	end
		
  end
end
