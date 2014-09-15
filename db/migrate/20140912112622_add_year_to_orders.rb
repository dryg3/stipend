class AddYearToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string :year
      t.integer :semester
    end
  end
end
