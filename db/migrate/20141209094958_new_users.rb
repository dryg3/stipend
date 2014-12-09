class NewUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :role, index: true
      t.remove :password_digest
      t.rename :email, :login
      t.rename :name, :surname
      t.string :firstname
      t.string :secondname
    end
  end
end
