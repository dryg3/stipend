class CertificatsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]

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
    #@certificat = Certificat.find(params[:id])
  end

  def index
    if params[:surname].nil? or params[:number].nil?
      @certificats  = []
    else
      if current_user.faculty.name == "all"
        @certificats  = Certificat.includes(:student=>{:student_groups=>:group})
      else
        @certificats = Certificat.includes(:student=>{:student_groups=>:group}).where(groups: {faculty_id:current_user.faculty_id})
      end
      @certificats = @certificats.find_all{|x| x.student.surname.include?  params[:surname]} unless params[:surname].empty?
      @certificats = @certificats.find_all{|x| x.number.include?  params[:number]} unless params[:number].empty?
    end
  end
  
  def edit
    # @certificat = Certificat.find(params[:id])
  end
  
  def update
    # @certificat = Certificat.find(params[:id])
    if @certificat.update(certificat_params)
      redirect_to @certificat
    else
      render 'edit'
    end
  end
  
  def destroy
    #@certificat = Certificat.find(params[:id])
    @certificat.destroy
   
    redirect_to certificats_path
  end

private
  def certificat_params
    params.require(:certificat).permit(:student_id,:number,:who,:when,:month_start,:year_start,:month_finish, :year_finish,:date_finish)
  end

  def correct_faculty
    @certificat  = Certificat.includes(:student=>{:student_groups=>:group}).find(params[:id])
    redirect_to help_url, notice: "Доступ заприщен" unless current_user.faculty.name == "all" || @certificat.student.student_groups.map{|x| x.group}.map{|x| x.faculty_id}.include?(current_user.faculty_id)
  end
end
