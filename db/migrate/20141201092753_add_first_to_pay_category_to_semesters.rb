class AddFirstToPayCategoryToSemesters < ActiveRecord::Migration
  def change
    change_table :pay_category_to_semesters do |t|
      t.integer :first
    end
  end
end
