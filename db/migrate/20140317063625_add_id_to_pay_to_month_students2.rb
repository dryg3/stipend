class AddIdToPayToMonthStudents2 < ActiveRecord::Migration
  def change
	change_table :pay_to_month_students do |t|
	 t.references :student, index: true
	t.remove :students_id
	 end
change_table :pay_category_to_semesters do |t|
	 t.remove :account_to_semesters_id
	 end
  end

end
