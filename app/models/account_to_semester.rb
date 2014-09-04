class AccountToSemester < ActiveRecord::Base
	belongs_to :faculty
	has_many :operations
	
	TYPE_ACСOUNT = { 0 => '1курс 1семестр', 1 => 'Повышенная', 2 =>'Социальная+Академическая' , 3=>'Резерв'}
	TYPE_ACСOUNT_SHORT = { 0 => '1к', 1 => 'П', 2 =>'С+А' , 3=>'Р'}
	
	validates_inclusion_of :type_account, in:  TYPE_ACСOUNT.keys,
	message: "Тип счета должен быть заполнин"
	
	# validates_uniqueness_of :type_account, :scope => :faculty_id ,
	# :allow_nil=>true,:allow_blank=>true,
	# message: "Такой счет уже существует"
	
	validates_associated :faculty,message: "Название факультета должно быть заполнино"
	validates_presence_of :faculty_id,
	message: "Название факультета должно быть заполнино"
	
	validates_presence_of :sum,
	message: "Сумма должна быть заполнина"
	
end
