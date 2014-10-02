class AddSurnameToStudents < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.string :surname_dp, :default => :surname
      t.string :surname_rp, :default => :surname
    end
    change_table :student_groups do |t|
      t.boolean :gos, :default => false
    end
    change_table :orders do |t|
      t.float :vspace, :default => 1.0
    end
  end
end
