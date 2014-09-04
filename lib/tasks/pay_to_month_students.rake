date=Date.today
sem=2
year="2013/2014"
f_id=3#fpmtf
task :pay3 => :environment do
  pays=PayCategoryToSemester.find(1)
  (pays.date_start.month.to_i).step(pays.date_finish.month.to_i,1) do |month|
    g = Group.where(" semester = ? AND faculty_id= ? AND year=?",sem,f_id,year)
    g.each{|g| p g.name}
    g.each  do |c|
      s = StudentGroup.where("refund= ? AND group_id = ? ",true,c.id)
      s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
      #p s.size
      s.each do |s|
        p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name+" "+s.group.kurs.to_s+"курс"
        kurs=s.group.kurs


    pay=PayToMonthStudent.new
    if pays.date_start.year==pays.date_finish.year
      pay.year=pays.date_start.year
    else
      Date.new(pays.date_start.year, month, 1)>=pays.date_start ? pay.year=pays.date_start.year : pay.year=pays.date_finish.year
    end
    pay.month=month
    pay.type_pay=0
    pay.student_id=s.student_id
    pay.social=0
    pay.academic=0
    pay.study=0
    pay.public=0
    pay.scientific=0
    pay.cultural=0
    pay.sports=0
    pay.surcharge=0

        if s.social && kurs==1  && sem==1
          pay.social+=pays.social1
        end
        if s.social && !(kurs==1  && sem==1)
          pay.social+=pays.social
        end

        if s.type_stipend==2 && kurs==1  && sem==1
          pay.academic+=pays.five1
        end
        if s.type_stipend==2 && !(kurs==1  && sem==1)
          pay.academic+=pays.five
        end

        if s.type_stipend==1 && kurs==1  && sem==1
          pay.academic+=pays.four1
        end
        if s.type_stipend==1 && !(kurs==1  && sem==1)
          pay.academic+=pays.four
        end

        if s.study
          pay.study+=pays.study
        end

        if s.public
          pay.public+=pays.public
        end

        if s.scientific
          pay.scientific+=pays.scientific
        end

        if s.cultural
          pay.cultural+=pays.cultural
        end

        if s.sports
          pay.sports+=pays.sports

        end

        pay.sum=pay.public+pay.scientific+pay.cultural+pay.sports+pay.study

        if s.type_stipend!=0 && s.social && (kurs==1 || kurs==2)
          pay.surcharge+=6307-pay.academic-pay.social-pay.sum
        end
        if (old=PayToMonthStudent.find_by(month:pay.month,year:pay.year,student_id:pay.student_id)).nil?
          pay.save!
        else
          # p old
          old.social=pay.social
          old.academic=pay.academic
          old.study=pay.study
          old.public=pay.public
          old.scientific=pay.scientific
          old.cultural=pay.cultural
          old.sports=pay.sports
          old.surcharge=pay.surcharge
          old.save!
        end


        end
        end
  end
end
task :pay2 => :environment do

g = Group.where(" semester = ? AND faculty_id= ? AND year=?",sem,f_id,year)
g.each{|g| p g.name}
g.each  do |c|
	s = StudentGroup.where("refund= ? AND group_id = ? ",true,c.id)
	 s.each{|s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name}
	#p s.size
	s.each do |s| 
	p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name+" "+s.group.kurs.to_s+"курс"
	kurs=s.group.kurs
		pay=PayToMonthStudent.new
		pay.year=date.year
		pay.month=date.month
		pay.type_pay=0
		pay.student_id=s.student_id
		pay.social=0
		pay.academic=0
		pay.study=0
		pay.public=0
		pay.scientific=0
		pay.cultural=0
		pay.sports=0
		pay.surcharge=0

cat =PayCategoryToSemester.where("date_finish>? AND date_start=? AND faculty_id=?",date ,Date.new(date.year,date.month,1),f_id)
#p cat
cat=cat[0]
		if s.social && kurs==1  && sem==1
			pay.social+=cat.social1
		end
		if s.social && !(kurs==1  && sem==1)
			pay.social+=cat.social
		end

		if s.type_stipend==2 && kurs==1  && sem==1
			pay.academic+=cat.five1
		end	
		if s.type_stipend==2 && !(kurs==1  && sem==1)
			pay.academic+=cat.five
		end

		if s.type_stipend==1 && kurs==1  && sem==1
			pay.academic+=cat.four1
		end	
		if s.type_stipend==1 && !(kurs==1  && sem==1)
			pay.academic+=cat.four
		end	

		if s.study
			pay.study+=cat.study
		end

		if s.public
			pay.public+=cat.public
		end	
	
		if s.scientific
			pay.scientific+=cat.scientific
		end	

		if s.cultural
			pay.cultural+=cat.cultural
		end

		if s.sports
			pay.sports+=cat.sports

		end

pay.sum=pay.public+pay.scientific+pay.cultural+pay.sports+pay.study

		if s.type_stipend!=0 && s.social && (kurs==1 || kurs==2)
				pay.surcharge+=6307-pay.academic-pay.social-pay.sum
		end	
#pay.save!
	p pay
end
	end

#
end
