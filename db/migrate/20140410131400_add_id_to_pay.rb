class AddIdToPay < ActiveRecord::Migration
  def change
  change_table :pay_to_month_students do |t|
	 t.references :students, index: true
	 t.references :account_to_semester, index: true
	 end
  end
end
