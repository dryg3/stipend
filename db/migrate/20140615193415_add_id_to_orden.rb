class AddIdToOrden < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.references :pay_category_to_semester, index: true
    end
  end
end
