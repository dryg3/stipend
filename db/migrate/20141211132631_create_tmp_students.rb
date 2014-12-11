class CreateTmpStudents < ActiveRecord::Migration
  def change
    create_table :tmp_students do |t|
      t.string   :firstname
      t.string   :surname
      t.string   :secondname
      t.integer  :old_id
      t.integer  :status
      t.integer  :user_id
    end
  end
end
