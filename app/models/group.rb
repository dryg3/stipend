class Group < ActiveRecord::Base
	has_many :student_groups
	has_many :students, through: :student_groups
	belongs_to  :faculty
	
	validates_uniqueness_of :name, :scope => [:semester,:year],
		message: "Название группы должно быть уникально" 
	validates_presence_of :name,:year,
		message: "Название группы должно быть заполнино"
		
	validates_length_of :name,  minimum: 4,
		message: "Минимум 4 символа"
		
	validates_format_of :kurs,with:  /[1-6]/ ,
		message: "Неправильно выбран курс"
	
	validates_format_of :semester,with:  /[1-2]/ ,
		message: "Неправильно выбран семестр"
		
	validates_format_of :year,  
		:allow_nil=>true,:allow_blank=>true, 
		with:  /\A[0-9][0-9][0-9][0-9]\/[0-9][0-9][0-9][0-9]\z/,
		message: "YYYY/YYYY"
end
