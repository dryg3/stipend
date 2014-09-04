class AddIdToPayCotrgoryToSemesters < ActiveRecord::Migration
  def change
	change_table :pay_category_to_semesters do |t|
	 t.references :account_to_semesters, index: true
	 end
  end
end
