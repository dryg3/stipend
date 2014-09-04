class CreateCertificats < ActiveRecord::Migration
  def change
    change_table :certificats do |t|
      t.remove :when
     end
  end
end
