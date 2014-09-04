class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :surname
      t.string :secondname
      t.text :text

      t.timestamps
    end
  end
end
