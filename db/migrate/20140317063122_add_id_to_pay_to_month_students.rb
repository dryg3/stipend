class AddIdToPayToMonthStudents < ActiveRecord::Migration
  def change
	change_table :pay_to_month_students do |t|
	 t.references :students, index: true
	 end
  end
end
