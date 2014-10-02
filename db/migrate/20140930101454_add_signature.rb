class AddSignature < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.rename :bottom, :signature
      t.string :bottom
    end
  end
end
