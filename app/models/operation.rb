class Operation < ActiveRecord::Base
	belongs_to :account_to_semester
  belongs_to :user

	TYPE_OP = { 0 => 'приход', 1 => 'расход',2 => 'новая'}
	TYPE_OP_SHORT = { 0 => 'П', 1 => 'Р'}
		
	validates_presence_of :type_op, :date_op, :account_to_semester_id, :sum,
	message: " поле должнобыть заполнено" 
	
	validates_inclusion_of :type_op, in: TYPE_OP.keys,
	message: "Тип операции должен быть заполнин"
	

   validates_acceptance_of  :sum,
	:allow_nil=>false, 
	:if => Proc.new { |a| a.sum<0},
    message: "Сумма должна быть >0" 
end
