class PayToMonthStudent < ActiveRecord::Base

belongs_to :student

		TYPE_PAY = { 0 => 'Планируется', 1 => 'Выплаченно'}
		TYPE_PAY_SHORT = { 0 => 'П', 1 => 'В'}
		
	validates_presence_of :type_pay, :year, :month,
		message: " поле должнобыть заполнено" 
	
	validates_inclusion_of :type_pay, in:  TYPE_PAY.keys,
		message: "Тип счета должен быть заполнин"

	validates_uniqueness_of :student_id, :scope => [:month,:year],	
	#validates_uniqueness_of :month, :scope => [:year],
		:allow_nil=>true,:allow_blank=>true,
		message: "Такой расчет уже существует"


end
