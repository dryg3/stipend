class Certificat < ActiveRecord::Base
  
  belongs_to :student
  
	validates_presence_of :number, :who, :when,  
	:month_start, :month_finish, :year_finish, :year_start, 
	:date_finish, :student_id,
	message: " поле должно быть заполнено"
    
    validates_associated :student,message: "ФИО должно быть заполнено"
    
	validates_inclusion_of :month_finish,  :month_start, in: 1..12 ,
    message: "неправильно указан месяц" 
    
	validates_acceptance_of  :year_finish, :month_finish,
	:allow_nil=>false,
	:if => Proc.new { |a| (!a.nil?) && Date.new(a.year_start,a.month_start,1) > Date.new(a.year_finish,a.month_finish,1)},
   message: "Дата окончания должен быть позже начала"

    validates_format_of :year_start,  :year_finish,
    :allow_nil=>true,:allow_blank=>true,
    with:  /\A20[0-9][0-9]\z/,
    message: "%{value} неправильно указан год"
=begin
	validates_acceptance_of  :year_finish,
	:allow_nil=>false, 
	:if => Proc.new { |a| (a.date_finish != Date.new(a.year_finish,a.month_finish,a.date_finish.day))and(a.date_finish != Date.new(a.year_finish,a.month_finish-1,a.date_finish.day))and(a.date_finish != Date.new(a.year_finish,a.month_finish+1,a.date_finish.day))},
    message: "Неправильно указана дата окончания"
=end
  	validates_uniqueness_of :number, :scope => [:who, :when],
	:allow_nil=>true,:allow_blank=>true,
	message: "Такая справка уже существует"
end
