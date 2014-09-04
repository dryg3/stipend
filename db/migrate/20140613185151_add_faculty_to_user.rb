class AddFacultyToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :faculty, index: true
    end
  end
end
