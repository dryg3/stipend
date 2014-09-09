class OperationsController < ApplicationController

  def new
    @operation = Operation.new
  end
  
  def create
    @operation = Operation.new(operation_params)
    @account=AccountToSemester.find(@operation.account_to_semester_id)
    @operation.user_id=current_user.id
    if @operation.type_op==0
      @account.sum+=@operation.sum
    elsif @operation.type_op==1
      @account.sum-=@operation.sum
    elsif @operation.type_op==2
      @operation.text<<"Предыдущая сумма равна #{@account.sum}."
      @account.sum=@operation.sum
    end
    @account.save!
     # raise @operation.inspect
    if @operation.save
     redirect_to @operation
     else
     render 'new'
	  end
  end
  
  def index
    if current_user.faculty.name=="all"
      @operations = Operation.all
    else
      ac=AccountToSemester.where("faculty_id = '#{current_user.faculty_id}'")
      @operations=[]
      ac.each{|a| @operations|=Operation.where("account_to_semester_id = '#{a.id}'")}
    end
  end

  def show
    @operation = Operation.find(params[:id])
  end

  def edit
    @operation = Operation.find(params[:id])
  end

  def update
    @operation = Operation.find(params[:id])
    if @operation.update(operation_params)
      redirect_to @operation
    else
      render action: 'edit'
    end
  end


  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy
     redirect_to operations_path
    
  end

  private

    def operation_params
      params.require(:operation).permit(:type_op, :sum, :date_op, :text,:account_to_semester_id)
    end
end
