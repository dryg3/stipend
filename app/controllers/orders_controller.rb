class OrdersController < ApplicationController
  def index
    if current_user.faculty.name=="all"
      @orders = Order.all
    else
      @orders = Order.where("faculty_id = '#{current_user.faculty_id}'")
    end
  end

  def show
    @order = Order.find(params[:id])
    @pays=PayCategoryToSemester.find(@order.pay_category_to_semester_id)
    @pay=PayToMonthStudent.where("month = ? AND year = ?",@pays.date_start.month, @pays.date_start.year)
    @student_groups=[]
    @groups=Group.where('year = ? AND semester = ?', @order.year, @order.sem_today)
    groups=[]
    @groups.each { |g| groups<<g.id }
    @pay.each do |pay|
      StudentGroup.where("student_id = ? ", pay.student_id).each do |s|
        @student_groups<<s if groups.include?(s.group_id)
      end
    end
  #raise @student_groups.inspect
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    @order.faculty_id=current_user.faculty_id
    @order.year=year_today
    @order.semester=sem_today
    #@order.pay_category_to_semester_id=params[:pay_category_to_semester_id]
    #raise @order.inspect
    if @order.save
      redirect_to @order
    else
      render 'new'
    end
  end

  def update
    @order = Order.find(params[:id])
    #raise params[:order][:list][6.to_s]["name1"].to_s.inspect
    @order.bottom=""
    arr=Array.new(8)
    for i in 0...7
      if i >= Order::LIST.size
        arr[params[:order][:list][i.to_s]["id"].to_i]=params[:order][:list][i.to_s]["name1"]<<"\t"<<params[:order][:list][i.to_s]["name2"]<<"\n"
      else
        unless params[:order][:list][i.to_s]["id"]==""
          arr[params[:order][:list][i.to_s]["id"].to_i]=Order::LIST[i][0].to_s<<"\t"<<Order::LIST[i][1].to_s<<"\n"
        end
      end
     # raise arr.inspect
    end

    for i in 0...arr.size
      @order.bottom<<arr[i] unless arr[i].nil?
    end
    #raise @order.bottom.inspect
    
    if @order.update(order_params)
      redirect_to action: 'index'
    else
      render action: 'edit'
    end

  end
  private

  def order_params
    params.require(:order).permit(:number, :type_order,:date,:up,:bottom,:pay_category_to_semester_id)
  end
end
