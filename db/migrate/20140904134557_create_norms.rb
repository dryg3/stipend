class CreateNorms < ActiveRecord::Migration
  def change
    create_table :norms do |t|
      t.string :name
      t.integer :number

      t.timestamps
    end
  end
end
