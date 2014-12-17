class AddShoToPayCategoryToSemesters < ActiveRecord::Migration
  def change
    change_table :pay_category_to_semesters do |t|
      t.integer :soc_five
      t.integer :soc_four
    end
  end
end
