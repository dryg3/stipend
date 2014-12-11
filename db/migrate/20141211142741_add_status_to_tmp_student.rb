class AddStatusToTmpStudent < ActiveRecord::Migration
  def change
    change_table :tmp_students do |t|
      t.text  :text
      t.integer  :student_id
    end
  end
end
