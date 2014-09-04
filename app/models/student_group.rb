class StudentGroup < ActiveRecord::Base
  belongs_to :student
  belongs_to :group
  
  
	TYPE_STIPEND = { 0 => 'нет', 1 => 'Хорошист', 2 =>'Отличник'}
  TYPE_STIPEND_SHORT = { 0 => '-', 1 => 'Х', 2 =>'О'}

	TYPE_ACADEM_STIPEND = { 0 => 'нет', 1 => 'учебная деятельность', 2 =>'общественая деятельность' , 3=>'науч-ис. деятельность', 4=>'культурная дечтельность', 5 =>'спортивная дечтельность'}
	TYPE_ACADEM_STIPEND_SHORT = { 0 => '-', 1 => 'У', 2 =>'О' , 3=>'Н', 4=>'К', 5 =>'С'}
  TYPE_ACADEM_STIPEND_MIN = { 0 => 'нет', 1 => 'учебн. деят.', 2 =>'общест. деят.' , 3=>'НИР', 4=>'культ. деят.', 5 =>'спорт. деят.'}


  #validates_associated :student,message: "ФИО студента должно быть заполнино"
	validates_presence_of :student_id,message: "ФИО студента должно быть заполнино"
	  #validates_associated :group,message: "Название группы должно быть заполнино"
	validates_presence_of :group_id,message: "Название группы должно быть заполнино"
	  
	validates_uniqueness_of :student_id,
	:scope => :group_id ,
	message: "Студент в группе должен быть уникален"
	  
	validates_inclusion_of :type_stipend,
	in:  TYPE_STIPEND.keys ,
	message: "Тип стипендии должен быть заполнин"
		
	
	validates_acceptance_of  :type_stipend,
	:allow_nil=>false, 
	:if => Proc.new { |a| 
		a.type_stipend==0 and (a.study==true or a.public==true or  a.scientific==true  or a.cultural==true  or a.sports==true)	
	},
    message: "Повышенную акад. стипендию могут получать только те, кто получает академ стипенд." 
    
	validates_acceptance_of  :commerce,
	:allow_nil=>false, 
	:if => Proc.new { |a| 
	  a.commerce==true and ( a.social==true or  a.study==true or a.public==true or  a.scientific==true  or a.cultural==true  or a.sports==true)
   	},
    message: "Комерсанты не имеют право получать стипендию" 
    

end

