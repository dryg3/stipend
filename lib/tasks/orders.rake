sem=1
year="2014/2015"
f_id=3#fpmtf
string=""

task :order => :environment do
  # @pays=PayCategoryToSemester.find(6)
  @pays=PayCategoryToSemester.find(7)
  @pay=PayToMonthStudent.where("month = ? AND year = ?",@pays.date_start.month, @pays.date_start.year)
  p @pay.size
  @student_groups=[]
  @groups=Group.where('year = ? AND semester = ? AND faculty_id = ? ', year,sem,@pays.faculty_id)
  groups=[]
  @groups.each do |g|
    groups<<g.id
  end

  @pay.each do |pay|
    StudentGroup.where("student_id = ? ", pay.student_id).each do |s|
      @student_groups<<s if groups.include?(s.group_id)
    end
  end
    @groups.sort_by{ |q| [ q.kurs, q.name] }.each{|q| p q.name}
  s_3=0
  s_4=0
  s_5=0
  s_6=0
  s_7=0
  s_8=0
  s_9=0
  s_11=0
  string<< "N;Фамилия И.О.;Социал.;Академ.;Учебн.;Общ.;Науч-ис.;Культ.;Спорт.;Срок оконч.;Итого;\r\n"
  string<< "1;2;3;4;5;6;7;8;9;10;11\r\n"
p string
  @groups.sort_by{ |q| [ q.kurs, q.name] }.each  do |c|
    n=0
    sum_3=0
    sum_4=0
    sum_5=0
    sum_6=0
    sum_7=0
    sum_8=0
    sum_9=0
    sum_11=0
@student_groups.sort_by{|q| q.student.surname}.each do |student_group|
  if c.name == student_group.group.name
    n+=1
  end
end
    string << ";;;;Группа;"<< c.name<<"\r\n" if n!=0
    n=0
p string

    @student_groups.sort_by{|q| q.student.surname}.each do |student_group|
      if c.name == student_group.group.name
        p student_group.student.surname
        n+=1
        #string << n.to_s<<"\r\n"
        pay=@pay.where("student_id = ?",student_group.student_id)[0]
        p pay
p " #{n.to_s}<<  #{pay.student.surname}  << #{pay.student.firstname[0]}<<  #{pay.student.secondname[0]}"

          string << n.to_s<< ";" << pay.student.surname.to_s << " " << pay.student.firstname[0].to_s<< ". " << pay.student.secondname[0].to_s<< ".;"
         p string
        if  pay.social!=0
            string << pay.social.to_s
            sum_3+= pay.social
            s_3+= pay.social
            end
        p string
          string<< ";"
          if pay.academic!=0
            string << pay.academic.to_s
            sum_4+= pay.academic
            s_4+= pay.academic
          end
        p string

          string<< ";"
          if pay.study!=0
            string << pay.study.to_s
            sum_5+= pay.study
            s_5+= pay.study
          end
        p string
          string<< ";"
          if pay.public!=0
            string << pay.public.to_s
            sum_6+= pay.public
            s_6+= pay.public
          end
        p string
          string<< ";"
          if pay.scientific!=0
            string << pay.scientific.to_s
            sum_7+= pay.scientific
            s_7+= pay.scientific
          end
        p string
          string<< ";"
          if pay.cultural!=0
            string << pay.cultural.to_s
            sum_8+= pay.cultural
            s_8+= pay.cultural
          end
        p string
          string<< ";"
          if pay.sports!=0
            string << pay.sports.to_s
            sum_9+= pay.sports
            s_9+= pay.sports
          end
        p string
          string<< ";"

          if pay.social!=0
            cer=Certificat.where('student_id = ?', student_group.student_id).select(:date_finish).sort_by { |q| q.date_finish }.last
            unless cer.nil?
              #=cer.date_finish.strftime("%d.%m.%Y")%>
              (cer.date_finish < @pays.date_finish) ? string<<cer.date_finish.strftime("%d.%m.%Y").to_s : string<<@pays.date_finish.strftime("%d.%m.%Y").to_s
            end
          end
        p string
          string<< ";"
          string << (pay.academic+pay.social+pay.sum).to_s<< ";\r\n"
          sum_11+= (pay.academic+pay.social+pay.sum)
          s_11+= (pay.academic+pay.social+pay.sum)


        p student_group.student.surname
      end
    end
    p "<< ;<< ; << #{sum_3.to_s}<< ; << #{sum_4.to_s}<< ; << #{sum_5.to_s}<< ; << #{sum_6.to_s}<< ; << #{sum_7.to_s}<< ; << #{sum_8.to_s}<< ; << #{sum_9.to_s}<< ; << ;<< #{sum_11.to_s}  "
    string<< ";"<< ";" << sum_3.to_s<< ";" << sum_4.to_s<< ";" << sum_5.to_s<< ";" << sum_6.to_s<< ";" << sum_7.to_s<< ";" << sum_8.to_s<< ";" << sum_9.to_s<< ";" << ";"<< sum_11.to_s << ";\r\n" if n!=0
  end
  string<< ";"<< "Итого:;" << s_3.to_s<< ";" << s_4.to_s<< ";" << s_5.to_s<< ";" << s_6.to_s<< ";" << s_7.to_s<< ";" << s_8.to_s<< ";" << s_9.to_s<< ";" << ";"<< s_11.to_s << ";\r\n"

  p string
  File.open('ИИТУ.xls', 'w'){ |file| file.write string }
  # File.open('ИЭТС.xls', 'w'){ |file| file.write string }
#дописать File.open('выходные данные.txt', 'a'){ |file| file.puts  string }
end