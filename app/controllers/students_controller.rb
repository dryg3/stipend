class StudentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :certificat, :pay, :edit, :update]
  before_action :no_admin, only: [:index, :new, :create, :destroy]

  def new
    @student = Student.new
  end
 
  def create
    @student = Student.new(student_params)

    if @student.save
      #redirect_to @student
      redirect_to :controller => 'student_groups', :action => 'index'
    else
      render 'new'
    end
  end
  
  def show
    #@student = Student.includes(:certificats,:groups,{:student_groups=>{:group=>:faculty}},:pay_to_month_students).find(params[:id])
  end

  def certificat
    #@student = Student.includes(:certificats).find(params[:student_id])
  end

  def pay
    #@student = Student.includes(:pay_to_month_students).find(params[:id])
  end

  def index
    @students = Student.all
    @students &= @students.find_all{|x| x.surname.include? params[:surname]} unless params[:surname].nil? or  params[:surname].empty?
    @students &= @students.find_all{|x| x.firstname.include? params[:firstname]} unless params[:firstname].nil? or  params[:firstname].empty?
    @students &= @students.find_all{|x| x.secondname.include? params[:secondname]} unless params[:secondname].nil? or  params[:secondname].empty?
    @students &= @students.find_all{|x| x.text.include? params[:text]} unless params[:text].nil? or  params[:text].empty?
  end

  def update
    #@student = Student.find(params[:id])
    if @student.update(student_params)
      redirect_to @student
    else
      render 'edit'
    end
  end
  
  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path
  end

  def edit
    #@student = Student.find(params[:id])
  end

private
  def student_params
    params.require(:student).permit(:firstname,:surname, :surname_dp, :surname_rp,:secondname, :text)
  end

  def correct_faculty
    @student = Student.includes(:certificats,:groups,{:student_groups=>{:group=>:faculty}},:pay_to_month_students).find(params[:id])
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all' || @student.student_groups.map{|x| x.group}.map{|x| x.faculty_id}.include?(current_user.faculty_id)
  end

  def no_admin
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end
end
