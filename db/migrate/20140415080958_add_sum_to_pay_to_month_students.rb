class AddSumToPayToMonthStudents < ActiveRecord::Migration
  def change
  	change_table :pay_to_month_students do |t|
		 t.integer :sum
	end
  end
end
