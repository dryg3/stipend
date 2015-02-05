class GroupsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_show, only: :show
  before_action :correct_faculty, except: :show

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group
    else
      render 'new'
    end
  end
  
  def show
    #@group = Group.find(params[:id])
  end

  def index
    if  params[:faculty].nil?
      @groups=[]
    else
      @groups=Group.all
      @groups=@groups.find_all{|x| x.faculty_id==params[:faculty].to_i} unless params[:faculty].empty?
      @groups=@groups.find_all{|x| x.year==params[:years]} unless params[:years].empty?
      @groups=@groups.find_all{|x| x.kurs==params[:kurs].to_i} unless params[:kurs].empty?
      @groups=@groups.find_all{|x| x.semester==params[:semester].to_i} unless params[:semester].empty?
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
   
    if @group.update(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
   
    redirect_to groups_path
  end

private
  def group_params
    params.require(:group).permit(:name, :year,:kurs,:semester,:faculty_id)
  end

  def correct_faculty
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end

  def correct_show
    @group = Group.includes(:student_groups=>:student).find(params[:id])
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all' || @group.faculty_id == current_user.faculty_id
  end
end
