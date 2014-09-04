class AddUserIdToOperation < ActiveRecord::Migration
  def change
    change_table :operations do |t|
      t.references :user, index: true
    end
  end
end
