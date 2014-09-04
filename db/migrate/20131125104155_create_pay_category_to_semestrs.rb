class CreatePayCategoryToSemestrs < ActiveRecord::Migration
  def change
    create_table :pay_category_to_semestrs do |t|
      t.string :semestr
      t.integer :year
      t.string :type

      t.timestamps
    end
  end
end
