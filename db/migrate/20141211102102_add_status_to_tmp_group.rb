class AddStatusToTmpGroup < ActiveRecord::Migration
  def change
    change_table :tmp_groups do |t|
      t.integer  :status
      t.integer  :user_id
    end
  end
end
