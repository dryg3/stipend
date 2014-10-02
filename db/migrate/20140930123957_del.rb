class Del < ActiveRecord::Migration
  def change
    change_column_default(:students, :surname_dp, nil)
    change_column_default(:students, :surname_rp, nil)
    remove_column(:student_groups, :gos)
    remove_column(:orders, :vspace)
  end
end
