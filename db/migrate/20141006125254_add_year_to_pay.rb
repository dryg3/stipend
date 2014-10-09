class AddYearToPay < ActiveRecord::Migration
  def change
    change_table :pay_category_to_semesters do |t|
      t.string :year
      t.integer :semester
    end

    change_table :orders do |t|
      t.integer :status
    end

    change_table :users do |t|
      t.string :tel
    end
  end
end
