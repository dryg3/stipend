class AddDataToPayCategoryToSemestrs < ActiveRecord::Migration
  def change
    change_table :pay_category_to_semestrs do |t|
      t.remove :semestr
      t.remove :year
      t.rename :type, :type_pay
      t.date :date_start
      t.date :date_finish
    end
  end
end
