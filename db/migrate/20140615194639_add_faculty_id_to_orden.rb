class AddFacultyIdToOrden < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.references :faculty, index: true
    end
  end
end
