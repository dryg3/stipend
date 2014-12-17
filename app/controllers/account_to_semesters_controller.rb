class AccountToSemestersController < ApplicationController
  before_action :signed_in_user
  before_action :operation, only: [:edit, :update]
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]

  def new
    @account_to_semester = AccountToSemester.new
  end

  def create
    @account_to_semester = AccountToSemester.new(account_to_semester_params)
    @account_to_semester.faculty_id=current_user.faculty.id
    @account_to_semester.semester=sem_today
    @account_to_semester.year=year_today
    if @account_to_semester.save
      redirect_to @account_to_semester
    else
      render 'new'
    end
  end
  
  def show
    #@account_to_semester = AccountToSemester.find(params[:id])
  end

  def index
    if params[:years].nil? or params[:years].empty?
      @account_to_semesters = faculty(AccountToSemester.includes(:faculty).where(year: year_today))
    else
      @account_to_semesters = faculty(AccountToSemester.includes(:faculty).where(year: params[:years].to_s))
    end
  end

  def edit
    #@account_to_semester = AccountToSemester.find(params[:id])
  end
  
  def update
    #@account_to_semester = AccountToSemester.find(params[:id])
    if @account_to_semester.update(account_to_semester_params)
      redirect_to @account_to_semester
    else
      render 'edit'
    end
  end
  
  def destroy
    #@account_to_semester = AccountToSemester.find(params[:id])
    @account_to_semester.destroy
    redirect_to account_to_semesters_path
  end

private
  def account_to_semester_params
    params.require(:account_to_semester).permit(:type_account, :sum,:faculty_id, :year, :semester)
  end

  def correct_faculty
    @account_to_semester = AccountToSemester.find(params[:id])
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all' || @account_to_semester.faculty_id == current_user.faculty_id
  end

  def operation
    @account_to_semester = AccountToSemester.find(params[:id])
    redirect_to controller: 'operations', action: 'new', account_to_semester_id: @account_to_semester.id unless current_user.faculty.name == "all"
  end
end
