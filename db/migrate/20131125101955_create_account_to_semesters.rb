class CreateAccountToSemesters < ActiveRecord::Migration
  def change
    create_table :account_to_semesters do |t|
      t.string :type
      t.integer :sum
      t.string :faculty

      t.timestamps
    end
  end
end
