class PayCategoryToSemestersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]
  before_action :correct_new, only: [:new]

  def kalkul
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where("commerce = ? AND groups.semester = ? AND groups.faculty_id = ? AND groups.year = ? AND account_to_semesters.type_account = ?",false,sem_today, params[:faculty_id], year_today,1).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.study=@s_g_all.find_all{|x| x.study}.size
    @category.public=@s_g_all.find_all{|x| x.public}.size
    @category.scientific=@s_g_all.find_all{|x| x.scientific}.size
    @category.cultural=@s_g_all.find_all{|x| x.cultural}.size
    @category.sports=@s_g_all.find_all{|x| x.sports}.size
    @sum[1]=@s_g_all.find_all{|x| x.study or x.public or x.scientific or x.cultural or x.sports}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    # [sum account,size, default, sum_end]
    @sum[3]=0
    @sum[3]+= @category.study* params[:study].to_i unless params[:study].nil? or params[:study].empty?
    @sum[3]+= @category.public* params[:public].to_i unless params[:public].nil? or params[:public].empty?
    @sum[3]+= @category.scientific* params[:scientific].to_i unless params[:scientific].nil? or params[:scientific].empty?
    @sum[3]+= @category.cultural* params[:cultural].to_i unless params[:cultural].nil? or params[:cultural].empty?
    @sum[3]+= @category.sports* params[:sports].to_i unless params[:sports].nil? or params[:sports].empty?
  end

  def stip1
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where('commerce = ? AND (groups.kurs = ? AND groups.semester = ?) AND groups.semester = ? AND groups.faculty_id= ? AND groups.year=? AND account_to_semesters.type_account = ?',false,1,1,sem_today, params[:faculty_id], year_today,0).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.social=@s_g_all.find_all{|x| x.social}.size
    @category.five=@s_g_all.find_all{|x| x.type_stipend == 2}.size
    @category.four=@s_g_all.find_all{|x| x.type_stipend == 1}.size
    @sum[1]=@s_g_all.find_all{|x| x.social or x.type_stipend == 2 or x.type_stipend == 1}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    @sum[3]=0
    @sum[3]+=@category.social* params[:social1].to_i unless params[:social1].nil? or params[:social1].empty?
    @sum[3]+=@category.five* params[:five1].to_i unless params[:five1].nil? or params[:five1].empty?
    @sum[3]+=@category.four* params[:four1].to_i unless params[:four1].nil? or params[:four1].empty?
  end

  def stip2
    @s_g_all=StudentGroup.includes(:group,{:group=>{:faculty=>:account_to_semesters}}).where('commerce = ? AND (groups.kurs != ? OR groups.semester != ?) AND groups.semester = ? AND groups.faculty_id= ? AND groups.year=? AND account_to_semesters.type_account = ?',false,1,1,sem_today, params[:faculty_id], year_today,2).references(:group)
    @sum=[@s_g_all.last.group.faculty.account_to_semesters[0].sum]
    @category = PayCategoryToSemester.new
    @category.social=@s_g_all.find_all{|x| x.social}.size
    @category.five=@s_g_all.find_all{|x| x.type_stipend == 2}.size
    @category.four=@s_g_all.find_all{|x| x.type_stipend == 1}.size
    @socfive=[@s_g_all.find_all{|x| x.type_stipend == 2 and x.social and (x.group.kurs == 1 or x.group.kurs == 2)}.size]
    @socfour=[@s_g_all.find_all{|x| x.type_stipend == 1 and x.social and (x.group.kurs == 1 or x.group.kurs == 2)}.size]
    @sum[1]=@s_g_all.find_all{|x| x.social or x.type_stipend == 2 or x.type_stipend == 1}.size
    @sum[1]!=0 ? @sum[2]=@sum[0]/@sum[1] : 0
    @socfive[1]=0 if (@socfive[1]=6307-params[:social].to_i-params[:five].to_i)<0
    @socfour[1]=0 if (@socfour[1]=6307-params[:social].to_i-params[:four].to_i)<0
    @sum[3]=0
    @sum[3]+=@category.social* params[:social1].to_i unless params[:social1].nil? or params[:social1].empty?
    @sum[3]+=@category.five* params[:five1].to_i unless params[:five1].nil? or params[:five1].empty?
    @sum[3]+=@category.four* params[:four1].to_i unless params[:four1].nil? or params[:four1].empty?
    @sum[3]+=@socfive[0]*@socfive[1]
    @sum[3]+=@socfour[0]*@socfour[1]
  end

  def new1
    @pay_category_to_semester = PayCategoryToSemester.new
  end

  def new
    @pay_category_to_semester = PayCategoryToSemester.new
  end

  def create
    @pay_category_to_semester = PayCategoryToSemester.new(pay_category_to_semester_params)
    @pay_category_to_semester.year=year_today
    @pay_category_to_semester.semester=sem_today
    if @pay_category_to_semester.save
      redirect_to @pay_category_to_semester
    else
      render 'new1'
    end
  end

  def show
    #@pay_category_to_semester = PayCategoryToSemester.find(params[:id])
  end

  def index
    @pay_category_to_semesters = faculty(PayCategoryToSemester.includes(:faculty))
  end

  def update
    #@pay_category_to_semester = PayCategoryToSemester.find(params[:id])
    if @pay_category_to_semester.update(pay_category_to_semester_params)
      redirect_to @pay_category_to_semester
    else
      render 'edit'
    end
  end

  def destroy
    #@pay_category_to_semester = PayCategoryToSemester.find(params[:id])
    @pay_category_to_semester.destroy
    redirect_to pay_category_to_semesters_path
  end

  def edit
    #@pay_category_to_semester = PayCategoryToSemester.find(params[:id])
  end

private
  def pay_category_to_semester_params
    params.require(:pay_category_to_semester).permit( :date_start,:date_finish,:social,:five,:four,:study,:public,:scientific,:cultural,:sports,:social1,:five1,:four1,:faculty_id)
  end

  def correct_faculty
    @pay_category_to_semester = PayCategoryToSemester.find(params[:id])
    redirect_to help_url, notice: "Доступ заприщен" unless current_user.faculty.name == "all" || @pay_category_to_semester.faculty_id == current_user.faculty_id
  end

  def correct_new
    redirect_to help_url, notice: "Доступ заприщен" unless current_user.faculty.name == "all"
  end
end
