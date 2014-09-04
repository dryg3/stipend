sem=1
year="2013/2014"
summa=10000
f_id=3#fpmtf


task :pay => :environment do
sum=0
sum_soc=0
sum_hor=0
sum_otl=0


  t =PayCategoryToSemester.new
    t.date_start=Date.new(2014,4,1)
    t.date_finish=Date.new(2014,4,30)
t.faculty_id=f_id
		t.social=0
		t.five=0
		t.four=0
		t.study=0
		t.public=0
		t.scientific=0
		t.cultural=0
		t.sports=0
		t.social1=0
		t.five1=0
		t.four1=0

if(sem==1)
	g = Group.find(:all,:conditions => ['(kurs = ? AND semester = ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
	g.each{|g| p g.name}
	g.each  do |c|

	s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false]) 
	# s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}

	#p s.size
	sum+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true]) 
	 #s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
	s.each do |s| 
	s.refund=true
		#s.save! 
	end
	#p s.size
	sum_soc+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2]) 
	#s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
	s.each do |s| 
	s.refund=true
		#s.save! 
	end
	#p s.size
	sum_otl+=s.size


	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1]) 
	#s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
	s.each do |s| 
	s.refund=true
		#s.save! 
	end
	#p s.size
	sum_hor+=s.size
	end
	p sum
	p sum_soc
	p sum_hor
	p sum_otl

=begin
=end

	#metod(sum_soc,sum_hor,sum_otl)

			t.social1=sum_soc*100
			t.five1=sum_otl*100
			t.four1=sum_hor*100

		p t
end

sum=0
sum_soc=0
sum_hor=0
sum_otl=0
	sum_1=0
	sum_2=0
	sum_3=0
	sum_4=0
	sum_5=0

g = Group.find(:all,:conditions => ['(kurs != ? OR semester != ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
g.each{|g| p g.name}
g.each  do |c|
	s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false]) 
	sum+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_soc+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_otl+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_hor+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND study=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_1+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND public=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_2+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND scientific=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_3+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND cultural=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_4+=s.size

	s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND sports=?',c.id,false,true]) 
	s.each do |s| 
		s.refund=true
		#s.save! 
	end
	sum_5+=s.size

end

p sum
p sum_1
p sum_2
p sum_3
p sum_4
p sum_5

	p sum
	p sum_soc
	p sum_hor
	p sum_otl

	t.social=sum_soc*100
	t.five=sum_otl*100
	t.four=sum_hor*100

		t.study=sum_1*100
		t.public=sum_2*100
		t.scientific=sum_3*100
		t.cultural=sum_4*100
		t.sports=sum_5*100
#t.save! 
p t
end



