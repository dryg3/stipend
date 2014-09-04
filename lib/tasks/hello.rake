task :hello => :environment do
     puts 'hello word'


#заполнение таблицы
#  g = Group.all
# g.each  do |c|
#c.year = "2013/2014" if c.year.nil?
#c.save!  
#end
#	p g


#  s = Student.find(:all,:conditions => ['surname LIKE ? ',"%Фед%"]) 
#  s&= Student.find(:all,:conditions => ['firstname = ? ',"Никита"]) 
#	p s

#создание нового
#  t =PayCategoryToSemester.new
#    t.date_start=Date.new(2014,4,1)
#    t.date_finish=Date.new(2014,4,30)
#    t.type_pay=0
#    t.account_to_semester_id=2
#	t.save! 
#	p t
sum=0
kurs=1
g = Group.find(:all,:conditions => ['kurs = ? AND semester = ?',kurs,kurs])
g.each  do |c|

s = StudentGroup.find(:all,:conditions => ['group_id = ? ',c.id,]) 
 s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
#p s.size
sum+=s.size
end
p sum
end
