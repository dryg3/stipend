class AddIdToPay2 < ActiveRecord::Migration
  def change
    change_table :pay_to_month_students do |t|
		 t.remove :students_id
		 t.remove :account_to_semester_id
		 t.integer :ac1_id
		 t.integer :ac2_id
		 t.integer :ac3_id
	 end
	 change_table :account_to_semesters do |t|
		t.string :year
	 end
  end

end
