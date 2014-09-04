class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :type_op
      t.integer :sum
      t.date :date_op
      t.string :text
	t.references :account_to_semesters, index: true
	
      t.timestamps
    end
  end
end
