class RemoveFirstToPayCategoryToSemesters < ActiveRecord::Migration
  def change
    remove_column( :pay_category_to_semesters,:four1)
    remove_column( :pay_category_to_semesters,:five1)
  end
end
