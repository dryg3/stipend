class PayToMonthStudentsController < ApplicationController
  def new
    @pay_to_month_student = PayToMonthStudent.new
  end
  def pay_metod
    @pay_to_month_student = PayToMonthStudent.new
    sem=1#sem_today
    year="2014/2015"#year_today
    f_id=current_user.faculty_id
    pays=PayCategoryToSemester.find(params[:pay_category_to_semester])
    (pays.date_start.month.to_i).step(pays.date_finish.month.to_i, 1) do |month|
      #
      p month
      g = Group.where(" semester = ? AND faculty_id= ? AND year=?", sem, f_id, year)
      g.each { |g| p g.name }
      g.each do |c|
        s = StudentGroup.where("group_id = ? ", c.id)
        s.each { |s| p s.student.surname+" "+s.student.firstname+" "+s.student.secondname+" "+s.group.name }
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

          pay.social+=pays.social1 if s.social && kurs==1 && sem==1
          pay.social+=pays.social if s.social && !(kurs==1 && sem==1)

          pay.academic+=pays.five1 if s.type_stipend==2 && kurs==1 && sem==1
          pay.academic+=pays.five if s.type_stipend==2 && !(kurs==1 && sem==1)

          pay.academic+=pays.four1 if s.type_stipend==1 && kurs==1 && sem==1
          pay.academic+=pays.four if s.type_stipend==1 && !(kurs==1 && sem==1)

          pay.study+=pays.study if s.study

          pay.public+=pays.public if s.public

          pay.scientific+=pays.scientific if s.scientific

          pay.cultural+=pays.cultural if s.cultural

          pay.sports+=pays.sports if s.sports

          pay.sum=pay.public+pay.scientific+pay.cultural+pay.sports+pay.study

          pay.surcharge+=6307-pay.academic-pay.social-pay.sum if s.type_stipend!=0 && s.social && (kurs==1 || kurs==2) && (6307-pay.academic-pay.social-pay.sum>0)

          p "qwertyuiop[vbhnjmkl;ghjkl"
          if (old=PayToMonthStudent.find_by(month: pay.month, year: pay.year, student_id: pay.student_id)).nil?

            p pay
            pay.save!  if (pay.sum+pay.academic+pay.social!=0)
          else
            p old
            old.social=pay.social
            old.academic=pay.academic
            old.study=pay.study
            old.public=pay.public
            old.scientific=pay.scientific
            old.cultural=pay.cultural
            old.sports=pay.sports
            old.surcharge=pay.surcharge
            p "=========================="
            p pay.sum+pay.academic+pay.social
            old.delete if (pay.sum+pay.academic+pay.social==0)
            old.save!
          end
          p pay

        end
      end
    end
  end
 
  def create
    @pay_to_month_student = PayToMonthStudent.new(pay_to_month_student_params)
    if @pay_to_month_student.save
      redirect_to @pay_to_month_student
    else
      render 'new'
    end
  end

  
  def show
    @pay_to_month_student = PayToMonthStudent.find(params[:id])
  end

  def index
    if current_user.faculty.name== "all"
      @pay_to_month_students =PayToMonthStudent.all
    else
       @pay_to_month_students = []
    end

    unless params[:pay_category_to_semester].nil?
      pay_metod
      pays=PayCategoryToSemester.find(params[:pay_category_to_semester])
      @pay_to_month_students = PayToMonthStudent.where("month = ? AND year = ?",pays.date_start.month,pays.date_start.year)
    end
  end
  
  def edit
    @pay_to_month_student = PayToMonthStudent.find(params[:id])
  end
  
  def update
    @pay_to_month_student = PayToMonthStudent.find(params[:id])
   
    if @pay_to_month_student.update(pay_to_month_student_params)
      redirect_to @pay_to_month_student
    else
      render 'edit'
    end
  end
  
  def destroy
    @pay_to_month_student = PayToMonthStudent.find(params[:id])
    @pay_to_month_student.destroy
   
    redirect_to pay_to_month_students_path
  end

private
  def pay_to_month_student_params
    params.require(:pay_to_month_student).permit(:year, :month, :social, :academic, :study, :public, :scientific, :cultural, :sports, :surcharge, :type_pay,:student_id)
  end

end
