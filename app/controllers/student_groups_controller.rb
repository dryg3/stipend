class StudentGroupsController < ApplicationController
  include StudentGroupsHelper
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
    #download(current_user.faculty.id) unless params[:download].nil? or params[:download].empty?
    @s_g_all=StudentGroup.includes(:group,:student,:student=>[:certificats,:pay_to_month_students])
    @student_groups=[]
    unless params[:surname].nil?
      @student_groups=@s_g_all
      unless  params[:surname].empty? and params[:firstname].empty? and params[:secondname].empty? and params[:text].empty?
        @student_groups &= @s_g_all.find_all{|x| x.student.surname.include? params[:surname]} unless params[:surname].nil? or  params[:surname].empty?
        @student_groups &= @s_g_all.find_all{|x| x.student.firstname.include? params[:firstname]} unless params[:firstname].nil? or  params[:firstname].empty?
        @student_groups &= @s_g_all.find_all{|x| x.student.secondname.include? params[:secondname]} unless params[:secondname].nil? or  params[:secondname].empty?
        @student_groups &= @s_g_all.find_all{|x| x.student.text.include? params[:text]} unless params[:text].nil? or  params[:text].empty?
      end

      if current_user.faculty.name=="all"
        params[:faculty].empty? ?  group=@s_g_all : group=@s_g_all.find_all{|x| x.group.faculty_id == params[:faculty].to_i}
      else
        group=@s_g_all.find_all{|x| x.group.faculty_id == current_user.faculty_id}
      end

      unless params[:gname].nil? or (params[:gname].empty? and params[:kurs].empty? and params[:semester].empty?)
        group &=@s_g_all.find_all{|x| x.group.name.include? params[:gname]} unless params[:gname].nil? or  params[:gname].empty?
        group &=@s_g_all.find_all{|x| x.group.year.include? params[:years].to_s} unless params[:years].nil? or  params[:years].empty?
        group &=@s_g_all.find_all{|x| x.group.kurs == params[:kurs].to_i} unless params[:kurs].nil? or  params[:kurs].empty?
        group &=@s_g_all.find_all{|x| x.group.semester == params[:semester].to_i} unless params[:semester].nil? or  params[:semester].empty?
      end
      @student_groups&=group
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
