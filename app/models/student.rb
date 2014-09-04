class Student < ActiveRecord::Base

  has_many :pay_to_month_students
  has_many :certificats
  has_many :student_groups
  has_many :groups, through: :student_groups
  
  validates_presence_of :firstname, :surname,
  message: " поле должнобыть заполнено" 
  
  # validates_format_of :firstname, :surname, :secondname,
  #   :allow_nil=>true,:allow_blank=>true,
  #   with:  /\A[А-ЯA-Z]/,
  #   message: "ФИО должны начинатся с большой буквы"





end
