class PayToMonthStudentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]

  def new
    @pay_to_month_student = PayToMonthStudent.new
  end

  def pay_metod
    @pays=PayCategoryToSemester.includes(:faculty=>{:groups=>{:student_groups=>{:student=>[:certificats,{:pay_to_month_students=>:student}]}}}).find(params[:pay_category_to_semester])
    st=@pays.faculty.groups.find_all{|x| x.semester==@pays.semester and x.year==@pays.year}.map{|x| x.student_groups}.flatten.find_all{|x| !x.commerce}
    (@pays.date_start.month.to_i).step(@pays.date_finish.month.to_i, 1) do |month|
        st.each do |s|
          kurs=s.group.kurs
          sem=s.group.semester
          pay=PayToMonthStudent.new
          if @pays.date_start.year==@pays.date_finish.year
            pay.year=@pays.date_start.year
          else
            Date.new(@pays.date_start.year, month, 1)>=@pays.date_start ? pay.year=@pays.date_start.year : pay.year=@pays.date_finish.year
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

          pay.social+=@pays.social1 if s.social && kurs==1 && sem==1
          pay.social+=@pays.social if s.social && !(kurs==1 && sem==1)

          pay.academic+=@pays.five1 if s.type_stipend==2 && kurs==1 && sem==1
          pay.academic+=@pays.five if s.type_stipend==2 && !(kurs==1 && sem==1)

          pay.academic+=@pays.four1 if s.type_stipend==1 && kurs==1 && sem==1
          pay.academic+=@pays.four if s.type_stipend==1 && !(kurs==1 && sem==1)

          pay.study+=@pays.study if s.study

          pay.public+=@pays.public if s.public

          pay.scientific+=@pays.scientific if s.scientific

          pay.cultural+=@pays.cultural if s.cultural

          pay.sports+=@pays.sports if s.sports

          pay.sum=pay.public+pay.scientific+pay.cultural+pay.sports+pay.study

          norm=Norm.find(1).number
          pay.surcharge+=norm-pay.academic-pay.social-pay.sum if s.type_stipend!=0 && s.social && ((kurs==1 && sem!=1)|| kurs==2) && (norm-pay.academic-pay.social-pay.sum>0)

          if (old=s.student.pay_to_month_students.find{|x| x.month==pay.month and x.year==pay.year}).nil?
            p pay
            pay.save!  if (pay.sum+pay.academic+pay.social!=0)
          else
          if pay.sum+pay.academic+pay.social!=0
            p old
            old.social=pay.social
            old.academic=pay.academic
            old.study=pay.study
            old.public=pay.public
            old.scientific=pay.scientific
            old.cultural=pay.cultural
            old.sports=pay.sports
            old.surcharge=pay.surcharge
            old.sum=pay.sum
            p "=========================="
            p pay.sum+pay.academic+pay.social
            #old.delete if (pay.sum+pay.academic+pay.social==0)
            old.save!
             end
          end
          p pay
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
    @pay_to_month_students = []
    if params[:pay_category_to_semester].nil?
      if current_user.faculty.name== "all"
        @pay_to_month_students =PayToMonthStudent.all
      end
    else
      pay_metod
      @pay_to_month_students = @pays.faculty.groups.find_all{|x| x.semester==@pays.semester and x.year==@pays.year}.map{|x| x.student_groups}.flatten.find_all{|x| !x.commerce}.map{|x| x.student.pay_to_month_students}.flatten.find_all{|x| Date.new(x.year,x.month,1)>=Date.new(@pays.date_start.year,@pays.date_start.month,1) and Date.new(x.year,x.month,1)<=Date.new(@pays.date_finish.year,@pays.date_finish.month,1)}
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

  def correct_faculty
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end
end
