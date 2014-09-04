class Orders < ActiveRecord::Migration
  def change
  change_table :orders do |t|
		 t.string :number
		 t.remove :namber
		 	end
  end
end
