class CertificatsController < ApplicationController

  def new
    @certificat = Certificat.new
  end

  def create
    @student = Student.find(params[:student_id])
    @certificat = @student.certificats.create(certificat_params)

    if @certificat.save
      redirect_to @certificat
    else
       render 'students/certificat'
      #render 'students/show'
    end
   # redirect_to :controller => 'student_groups', :action => 'index'
  end
  
  def show
    @certificat = Certificat.find(params[:id])
  end

  def index

#a=Certificat.includes(:student=>[:student_groups=>[:group=>:faculty]])
# a.each{|g|  group.each{|q| p q.name if q.faculty_id=7}}
    if params[:surname].nil? or params[:number].nil?
      @certificats  = []
    elsif params[:surname].empty? and params[:number].empty?
      if current_user.faculty.name== "all"
        @certificats  = Certificat.all
      else
        student_group=[]
        student =[]
        certificats = []
        group=Group.where("faculty_id = '#{current_user.faculty_id}' AND year = '#{year_today}' AND semester = '#{sem_today}'")
        group.each { |s| student_group|=StudentGroup.where("group_id = ? ", s.id) }
        student_group.each { |s| student|=Student.where("id = ?",s.student_id) }
        student.each{ |s| certificats |=Certificat.where("student_id = '#{s.id}'")}
        @certificats  = Certificat.all
        @certificats &= certificats
    end
    else




      student = Student.where("surname LIKE '%#{params[:surname]}%'") unless params[:surname].empty?
      certificats = []
      @certificats  = Certificat.all
      @certificats &= Certificat.where("number LIKE '%#{params[:number]}%'") unless params[:number].empty?
      student.each{ |s| certificats |=Certificat.where("student_id = '#{s.id}'")} unless student.nil?
      @certificats &= certificats
    end
  end
  
  def edit
    @certificat = Certificat.find(params[:id])
  end
  
  def update
    @certificat = Certificat.find(params[:id])
   
    if @certificat.update(certificat_params)
      redirect_to @certificat
    else
      render 'edit'
    end
  end
  
  def destroy
    @certificat = Certificat.find(params[:id])
    @certificat.destroy
   
    redirect_to certificats_path
  end

private
  def certificat_params
    params.require(:certificat).permit(:student_id,:number,:who,:when,:month_start,:year_start,:month_finish, :year_finish,:date_finish)
  end
end
