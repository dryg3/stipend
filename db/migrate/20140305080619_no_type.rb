class NoType < ActiveRecord::Migration
  def change
	change_table :account_to_semesters do |t|
		t.remove :type_account
		t.integer :type_account
	end

	change_table :orders do |t|
		t.remove :type
		t.integer :type_order
	end

	change_table :pay_category_to_semestrs do |t|
		t.remove :type_pay
		t.integer :type_pay
	end

	change_table :pay_to_month_students do |t|
		t.remove :type
		t.integer :type_pay
	end

	change_table :student_groups do |t|
		t.remove :type
	end

	drop_table :comments
	drop_table :groups_student_groups
	drop_table :posts
  end
end
