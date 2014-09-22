class PayCategoryToSemester < ActiveRecord::Base
	belongs_to :faculty
  has_many :orders

	validates_presence_of  :date_start,:date_finish,
	:social,:five,:four,
	:study,:public,:scientific,:cultural,:sports,
	:social1,:five1,:four1,
	:faculty_id,
	message: " поле должнобыть заполнено" 
	
	
	validates_acceptance_of  :date_finish,
	:allow_nil=>false, 
	:if => Proc.new { |a| a.date_start > a.date_finish},
    message: "Дата оканчания должен быть позже начала" 
    
    validates_acceptance_of  :date_finish,
	:allow_nil=>false, 
	:if => Proc.new { |a| a.date_finish.month==a.date_finish.next.month},
    message: "Приказ делается по конец месяца" 
    
    validates_acceptance_of  :date_start,
	:allow_nil=>false, 
	:if => Proc.new { |a| a.date_start.day!=1},
    message: "Приказ делается c 1-го числа" 
    
     validates_acceptance_of  :date_start,
	:allow_nil=>false, 
	:if => Proc.new { |a| 
	!(((a.date_start.month>=7 or a.date_start.month==1) and((a.date_finish.month==1 and a.date_finish.year==a.date_start.year+1) or a.date_finish.year==a.date_start.year)) or (a.date_start.month>=2 and a.date_start.month<7 	and a.date_finish.month<7 and  a.date_finish.year==a.date_start.year))},
    message: "Приказ делается на один семестр" 
    
	validates_uniqueness_of :faculty_id, :scope => [:date_start, 	:date_finish],
	:allow_nil=>true,:allow_blank=>true,
	message: "Такой расчет уже существует"
	
end
