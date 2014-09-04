class CreatePayToMonthStudents < ActiveRecord::Migration
  def change
    create_table :pay_to_month_students do |t|
      t.integer :year
      t.integer :month
      t.integer :social
      t.integer :academic
      t.integer :study
      t.integer :public
      t.integer :scientific
      t.integer :cultural
      t.integer :sports
      t.string :type
      t.integer :surcharge

      t.timestamps
    end
  end
end
