class CreateGroupStudentGroupsJoinTable < ActiveRecord::Migration
  def change
	create_join_table :groups, :student_groups
  end
end
