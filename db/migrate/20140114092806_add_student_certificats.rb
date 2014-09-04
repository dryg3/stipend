class AddStudentCertificats < ActiveRecord::Migration
  def change
    change_table :certificats do |t|
      t.references :student, index: true
    end
  end
end
