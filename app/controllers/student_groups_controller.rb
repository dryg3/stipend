class StudentGroupsController < ApplicationController
  load_and_authorize_resource
  #http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
def new
  @student_group = StudentGroup.new
end
def create
  @student_group = StudentGroup.new(student_group_params)
 
  if @student_group.save
    redirect_to @student_group
  else
    render 'new'
  end
end
  
  def show
    @student_group = StudentGroup.find(params[:id])
  end

#  def index
#    @student_groups = StudentGroup.accessible_by(current_ability)
#  end

  def index
    @groups=[]
    g= []
    @student_groups=[]
    unless params[:surname].nil?
      unless  (params[:surname].empty? and params[:firstname].empty? and params[:secondname].empty? and params[:text].empty?)
        student = Student.all
        student &= Student.where("surname LIKE '%#{params[:surname]}%'") unless params[:surname].nil? or  params[:surname].empty?
        student &= Student.where("firstname LIKE '%#{params[:firstname]}%'") unless params[:firstname].nil? or  params[:firstname].empty?
        student &= Student.where("secondname LIKE '%#{params[:secondname]}%'") unless params[:secondname].nil? or  params[:secondname].empty?
        student &= Student.where("text LIKE '%#{params[:text]}%'") unless params[:text].nil? or  params[:text].empty?
        student.each { |s| @student_groups|=StudentGroup.where("student_id = ? ", s.id)}
        else
        @student_groups=StudentGroup.all
      end

      if current_user.faculty.name=="all"
        params[:faculty].empty? ?  group=Group.all : group=Group.where("faculty_id = '#{params[:faculty]}'")
      else
        group=Group.where("faculty_id = '#{current_user.faculty_id}'")
      end

      unless params[:gname].nil? or (params[:gname].empty? and params[:kurs].empty? and params[:semester].empty?)
        group &=Group.where("name LIKE '%#{params[:gname]}%'") unless params[:gname].nil? or  params[:gname].empty?
        group &=Group.where("year LIKE '%#{params[:years].to_s}%'")unless params[:years].nil? or  params[:years].empty?
        group &=Group.where("kurs = ?",params[:kurs]) unless params[:kurs].nil? or  params[:kurs].empty?
        group &=Group.where("semester = ? ",params[:semester])unless params[:semester].nil? or  params[:semester].empty?
      end

      group.each { |s| g|=StudentGroup.where("group_id = ? ", s.id) }
      @student_groups&=g

      g=[]
      @student_groups.each { |s| g<< s.group_id}
      g.uniq.each { |s|  @groups|=Group.where('id = ? ',s)}

    end

  end
  
  def edit
    @student_group = StudentGroup.find(params[:id])
  end
  
  def update
    @student_group = StudentGroup.find(params[:id])
   
    if @student_group.update(student_group_params)
      redirect_to @student_group
    else
      render 'edit'
    end
  end
  
  def destroy
    @student_group = StudentGroup.find(params[:id])
    @student_group.destroy
   
    redirect_to student_groups_path
  end

  
  
private
  def student_group_params
    params.require(:student_group).permit(:type_stipend, :refund, :commerce, :student_id, :group_id,:social, :study,:public, :scientific,:cultural, :sports)
  end
end
