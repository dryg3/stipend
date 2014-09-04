class AddNameToFaculty < ActiveRecord::Migration
  def change
    change_table :faculties do |t|
      t.string :short_name
    end
  end
end
