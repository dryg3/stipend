class OperationsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]

  def new
    @operation = Operation.new
  end
  
  def create
    @operation = Operation.includes(:account_to_semester).new(operation_params)
    @operation.user_id=current_user.id
    @operation.date_op=Date.today
    @operation.text<<"Предыдущая сумма равна #{@operation.account_to_semester.sum}."
    if @operation.type_op==0
      @operation.account_to_semester.sum+=@operation.sum
    elsif @operation.type_op==1
      @operation.account_to_semester.sum-=@operation.sum
    elsif @operation.type_op==2
      @operation.account_to_semester.sum=@operation.sum
    end
    @operation.account_to_semester.save!
     # raise @operation.inspect
    if @operation.save
     redirect_to @operation.account_to_semester
     else
     render 'new'
	  end
  end
  
  def index
    if current_user.faculty.name=="all"
      @operations = Operation.includes({:account_to_semester=>:faculty},:user)
    else
      @operations = Operation.includes({:account_to_semester=>:faculty},:user).where(faculties:{id: current_user.faculty_id})
    end
  end

  def show
    #@operation = Operation.find(params[:id])
  end

  def edit
    #@operation = Operation.find(params[:id])
  end

  def update
    #@operation = Operation.find(params[:id])
    if @operation.update(operation_params)
      redirect_to @operation
    else
      render action: 'edit'
    end
  end

  def destroy
    #@operation = Operation.find(params[:id])
    @operation.destroy
    redirect_to operations_path
  end

private
  def operation_params
    params.require(:operation).permit(:type_op, :sum, :date_op, :text,:account_to_semester_id)
  end

  def correct_faculty
    @operation = Operation.find(params[:id])
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end
end
