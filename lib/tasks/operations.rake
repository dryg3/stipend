date=Date.today
sem=1
year="2013/2014"
f_id=1#fpmtf

task :op => :environment do 
	sum_up=0
	sum_ac=0
	sum_ac1=0
	sum_s=0

	s=[]
	if(sem==1)
		g = Group.find(:all,:conditions => ['(kurs = ? AND semester = ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
		g.each  do |c|
			s =StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
			s.each do |s|
				pay=PayToMonthStudent.find(:all,:conditions => ['year=? AND month =? AND student_id = ?',date.year,date.month,s.student_id])
				p pay 	
				pay.each do |pay|
					sum_up+=pay.sum
					sum_ac1+=pay.academic+pay.social
					sum_s+=pay.surcharge
				end
			end
		end
	end
	s=[]
	g = Group.find(:all,:conditions => ['(kurs != ? OR semester != ?)  AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
	g.each  do |c|
		s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
		s.each do |s|
			pay=PayToMonthStudent.find(:all,:conditions => ['year=? AND month =? AND student_id = ?',date.year,date.month,s.student_id]) 	
			p pay
			pay.each do |pay|
				sum_up+=pay.sum
				sum_ac+=pay.academic+pay.social
				sum_s+=pay.surcharge
			end

		end
	end
p sum_up
p sum_ac
p sum_ac1
p sum_s


if (sum_s!=0)
acc=AccountToSemester.find(:all,:conditions => ['semester = ? AND faculty_id= ? AND year=? AND type_account=?',sem,f_id,year,0])[0]
acc.sum-=sum_ac1
p acc
o=Operation.new
    o.sum=sum_ac1
   	o.date_op=date
  	o.text="Начисление стипендии за  #{date.month}.#{date.year}"
    o.account_to_semester_id=acc.id
    o.type_op=1
o.save!
p o
end
if (sum_s!=0)
acc=AccountToSemester.find(:all,:conditions => ['semester = ? AND faculty_id= ? AND year=? AND type_account=?',sem,f_id,year,1])[0]
acc.sum-=sum_up
p acc
o=Operation.new
    o.sum=sum_up
   	o.date_op=date
  	o.text="Начисление стипендии за #{date.month}.#{date.year}"
    o.account_to_semester_id=acc.id
    o.type_op=1
o.save!
p o
end
if (sum_s!=0)
acc=AccountToSemester.find(:all,:conditions => ['semester = ? AND faculty_id= ? AND year=? AND type_account=?',sem,f_id,year,2])[0]
acc.sum-=sum_ac
p acc

o=Operation.new
    o.sum=sum_ac
   	o.date_op=date
  	o.text="Начисление стипендии за   #{date.month}.#{date.year}"
    o.account_to_semester_id=acc.id
    o.type_op=1
o.save!
p o
end
if (sum_s!=0)
acc=AccountToSemester.find(:all,:conditions => ['semester = ? AND faculty_id= ? AND year=? AND type_account=?',sem,f_id,year,3])[0]
acc.sum-=sum_s
p acc

o=Operation.new
    o.sum=sum_s
   	o.date_op=date
  	o.text="Начисление стипендии за  #{date.month}.#{date.year}"
    o.account_to_semester_id=acc.id
    o.type_op=1
o.save!
p o
end
end
