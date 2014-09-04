class StudentsController < ApplicationController
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
    @student = Student.find(params[:id])
  end

  def certificat
    @student = Student.find(params[:student_id])
  end

  def pay
    @student = Student.find(params[:id])
  end

  def index
    @students = Student.all
    @search=Student.all
    student &= Student.find(:all, :conditions => ['surname LIKE ? ', "%#{params[:surname]}%"]) unless params[:surname].nil? or  params[:surname].empty?
    student &= Student.find(:all, :conditions => ['firstname LIKE ? ', "%#{params[:firstname]}%"]) unless params[:firstname].nil? or  params[:firstname].empty?
    student &= Student.find(:all, :conditions => ['secondname LIKE ?', "%#{params[:secondname]}%"]) unless params[:secondname].nil? or  params[:secondname].empty?
    student &= Student.find(:all, :conditions => ['text LIKE ? ', "%#{params[:text]}%"]) unless params[:text].nil? or  params[:text].empty?
  end



  def edit
    @student = Student.find(params[:id])
  end
  
  def update
    @student = Student.find(params[:id])
   
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
    @student = Student.find(params[:id])
  end
  
  
  
  private
  def student_params
    params.require(:student).permit(:firstname,:surname, :secondname, :text)
  end
end
