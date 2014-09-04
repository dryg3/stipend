class NoSemestrs < ActiveRecord::Migration
  def change
drop_table :pay_category_to_semestrs
  end
end
