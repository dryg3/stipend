class AddToPay < ActiveRecord::Migration
  def change
	change_table :pay_to_month_students do |t|
		 t.remove :ac1_id
		 t.remove :ac2_id
		 t.remove :ac3_id
	end
	
	change_table :account_to_semesters do |t|
		 t.integer :semester
	end
	
	change_table :student_groups do |t|
      t.remove :academic
    end
    
    drop_table :pay_category_to_semesters
    
    create_table :pay_category_to_semesters do |t|
	t.date     :date_start
    t.date     :date_finish
      t.integer :social
      t.integer :five
      t.integer :four
      t.integer :study
      t.integer :public
      t.integer :scientific
      t.integer :cultural
      t.integer :sports
      
      t.integer :social1
      t.integer :five1
      t.integer :four1
      
      t.timestamps	
	end
  end
end
