class RenameToAccountToSemesters < ActiveRecord::Migration
  def change
    change_table :account_to_semesters do |t|
      t.rename :type, :type_account

    end
  end
end
