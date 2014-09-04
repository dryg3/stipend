class CreatePayCategoryToSemesters < ActiveRecord::Migration
  def change
    create_table :pay_category_to_semesters do |t|
	t.date     :date_start
    t.date     :date_finish
    t.integer  :type_pay

      t.timestamps
    end
  end
end
