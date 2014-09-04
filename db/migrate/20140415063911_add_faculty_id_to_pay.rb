class AddFacultyIdToPay < ActiveRecord::Migration
  def change
  change_table :pay_category_to_semesters do |t|
   t.references :faculty, index: true
  end
end
end
