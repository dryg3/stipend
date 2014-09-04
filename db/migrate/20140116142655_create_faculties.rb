class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
    end
    change_table :account_to_semesters do |t|
      #t.rename :upccode, :upc_code
     # t.rename :sumfaculty, :sum
      t.remove :faculty
      t.references :faculty, index: true
    end
  end
end
