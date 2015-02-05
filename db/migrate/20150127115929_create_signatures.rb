class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.string :surname
      t.string :firstname
      t.string :secondname
      t.string :position
      t.integer :type_sign
      t.integer :number
      t.references :faculty, index: true
      t.timestamps
    end
  end
end
