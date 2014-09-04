task :h => :environment do
    
=begin
#заполнение таблицы
 g = Group.all
 g.each  do |c|
c.faculty_id=c.name.to_i/100%10%3+1
#c.semester=(c.name.to_i/1000+1)%2+1
c.save!  
end
#	p g



 t =PayCategoryToSemester.all
t.each  do	|t|
(t.sum.nil?) ? (t.sum=333) : (t.sum*=100)
	t.save! 
end
	p t



s = StudentGroup.all
s.each do |s| 
s.refund=false
	s.save! 
end

pay=PayToMonthStudent.all
q=0
pay.each do |s| 
q+=1
s.student_id=q
s.save!
p s
end



o=Order.new
o.number="1/ст"
o.date=Date.today
o.type_order=0
o.up="qq"
o.bottom="ww"
o.save!
p o

  @groups=[]
      g= []
  @student_groups=[]
  student = Student.all
  student = Student.find(:all,:conditions => ['surname LIKE ? ',"%Фед%"])
  student&= Student.find(:all,:conditions => ['firstname = ? ',"Никита"])
#	p s
p student

   student.each { |s| @student_groups|=StudentGroup.find(:all, :conditions => ['student_id LIKE ? ', s.id]) }

   p @student_groups
  group=Group.find(:all,:conditions => ['name LIKE ? ',"%13%"])
# @student_groups=StudentGroup.all
  p group
  group.each { |s| g|=StudentGroup.find(:all, :conditions => ['group_id LIKE ? ', s.id]) }

   @student_groups&=g
p @student_groups
g=[]

 @student_groups.each { |s| g<<s.group_id}
 g.uniq.each { |s|  @groups|=Group.find(:all,:conditions => ['id LIKE ? ',s])}
p  @groups

student = StudentGroup.all
s= student.group.find(params[:id])
  p s


s = User.all
s.each  do |s|
s.name="1"
s.email="2"
  s.password_digest="fddgf"
s.save!
end

p s

s=Certificat.find(:all, :conditions => ['student_id LIKE ? ', 3])
#.sort_by { |s| s.date_finish}.last.date_finish
  unless s.empty? then
    p s
  else
    p "qq"
  end
=end
#
# pay=PayToMonthStudent.find(:all, :conditions => ['student_id LIKE ? ', 1]).sort_by { |s| Date.new(s.year,s.month,1)}
#   p pay

def pay_category(account)
  sem=account.semester
  year=account.year
  f_id=account.faculty_id#fpmtf

  sum=0
  sum_soc=0
  sum_hor=0
  sum_otl=0

  @category = PayCategoryToSemester.new
  @category.faculty_id=f_id
  @category.social=0
  @category.five=0
  @category.four=0
  @category.study=0
  @category.public=0
  @category.scientific=0
  @category.cultural=0
  @category.sports=0
  @category.social1=0
  @category.five1=0
  @category.four1=0
  if(sem==1)
    g = Group.find(:all,:conditions => ['(kurs = ? AND semester = ?) AND semester = ? AND faculty_id= ? AND year=?',1,1,sem,f_id,year])
    g.each  do |c|

      s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
      sum+=s.size

      s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true])
      s.each do |s|
        s.refund=true
        s.save!
      end
      sum_soc+=s.size

      s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2])
      s.each do |s|
        s.refund=true
        s.save!
      end
      sum_otl+=s.size


      s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1])
      s.each do |s|
        s.refund=true
        s.save!
      end
      sum_hor+=s.size
    end


    @category.social1=sum_soc
    @category.five1=sum_otl
    @category.four1=sum_hor


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
  g.each  do |c|
    s = StudentGroup.find(:all,:conditions => ['group_id = ? AND commerce= ?',c.id,false])
    sum+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND social=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_soc+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,2])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_otl+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND type_stipend=?',c.id,false,1])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_hor+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND study=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_1+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND public=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_2+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND scientific=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_3+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND cultural=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_4+=s.size

    s = StudentGroup.find(:all,:conditions =>  ['group_id = ? AND commerce= ? AND sports=?',c.id,false,true])
    s.each do |s|
      s.refund=true
      s.save!
    end
    sum_5+=s.size

  end
#metod(sum_soc,sum_hor,sum_otl)
  @category.social=sum_soc
  @category.five=sum_otl
  @category.four=sum_hor

#metod(sum_soc,sum_hor,sum_otl)

  @category.study=sum_1
  @category.public=sum_2
  @category.scientific=sum_3
  @category.cultural=sum_4
  @category.sports=sum_5

#@pay_category_to_semester.save!
  end
@account_to_semester = AccountToSemester.find(:all, :conditions => ['faculty_id LIKE ? ', 3])[0]
  pay_category(@account_to_semester)
  p @category
end