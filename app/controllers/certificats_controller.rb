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
    if params[:surname].nil? or params[:number].nil?
      @certificats  = []
    else
      student = Student.where("surname LIKE '%#{params[:surname]}%'") unless params[:surname].empty?
      certificats = []
      @certificats  = Certificat.all
      @certificats &= Certificat.where("number LIKE '%#{params[:number]}%'") unless params[:number].empty?
      student.each{ |s| certificats |=Certificat.where("student_id = '#{s.id}'")} unless student.nil?
      @certificats &= certificats unless certificats ==[]
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
