class AddIdToOperation < ActiveRecord::Migration
  def change
  	change_table  :operations  do |t|
	 t.references :account_to_semester, index: true
	t.remove :account_to_semesters_id
	 end
  end
end
