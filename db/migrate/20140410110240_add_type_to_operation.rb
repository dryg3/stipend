class AddTypeToOperation < ActiveRecord::Migration
  def change
  	change_table :operations do |t|
		t.remove :type_op
		t.integer :type_op
	end
  end
end
