class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :namber
      t.date :date
      t.string :type
      t.text :up
      t.text :bottom

      t.timestamps
    end
  end
end
