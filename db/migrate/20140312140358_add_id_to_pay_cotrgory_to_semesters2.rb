class AddIdToPayCotrgoryToSemesters2 < ActiveRecord::Migration
  def change
	change_table :pay_category_to_semesters do |t|
	 t.remove :account_to_semesters
	 t.references :account_to_semester, index: true
	 end
  end
end

