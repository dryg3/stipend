class AddKursToGroups < ActiveRecord::Migration
  def change  
		change_table :groups do |t|
		t.integer :kurs
	end
  end
end
