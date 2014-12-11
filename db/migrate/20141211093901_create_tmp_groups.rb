class CreateTmpGroups < ActiveRecord::Migration
  def change
    create_table :tmp_groups do |t|
      t.string  :name
      t.string  :year
      t.integer :faculty_id
      t.integer :old_id
      t.integer :kurs
      t.integer :semester
      t.integer :group_id
    end
  end
end
