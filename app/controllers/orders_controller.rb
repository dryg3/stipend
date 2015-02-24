class OrdersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_faculty, only: [:show, :edit, :update, :destroy]

  def index
    @orders = faculty(Order.includes(:faculty)).sort_by{ |x| [x.status, x.faculty_id, Date.new-x.date, -x.number.to_i]}
    if params[:number].nil?
      @orders = @orders[0..17]
    else
      @orders = @orders.find_all{|x| x.year==params[:year]} unless params[:year].empty?
      @orders = @orders.find_all{|x| x.faculty_id==params[:faculty].to_i} unless params[:faculty].nil? or params[:faculty].empty?
      @orders = @orders.find_all{|x| x.number.include? params[:number]} unless params[:number].empty?
      @orders = @orders.find_all{|x| x.date==Date.strptime(params[:date], '%d.%m.%Y')} unless params[:date].empty?
      @orders = @orders.find_all{|x| x.type_order == params[:type_order].to_i} unless params[:type_order].empty?
      @orders = @orders.find_all{|x| x.status == 0} unless params[:status].nil?
    end
  end

  def show
    #@order = Order.includes(:pay_category_to_semester).find(params[:id])
    @order = Order.includes([{:faculty=>{:groups=>{:student_groups=>{:student=>[:pay_to_month_students,:certificats]}}}},:pay_category_to_semester]).where('groups.year = ? AND groups.semester = ? AND pay_to_month_students.year = ? AND pay_to_month_students.month = ?', @order.year, @order.semester, @order.pay_category_to_semester.date_start.year,@order.pay_category_to_semester.date_start.month).references(:faculty).find(params[:id])
    if  [0,1,2,6,7].include?(@order.type_order)
      @student_groups=@order.faculty.groups.find_all{|x| x.kurs != 1 or x.semester != 1}.map{|x| x.student_groups}.flatten
    elsif [3,4,5].include?(@order.type_order)
      @student_groups=@order.faculty.groups.find_all{|x| x.kurs == 1 and x.semester == 1}.map{|x| x.student_groups}.flatten
    end
  end

  def new
    @order = Order.new
  end

  def edit
    #@order = Order.find(params[:id])
    @signature=Signature.where(type_sign: 1).find_all{ |x| x.faculty_id.nil? or x.faculty_id.to_i==current_user.faculty_id.to_i}.sort_by { |x| x.number.nil? ? 100: x.number} if [0,3,7].include?(@order.type_order)
    @signature=Signature.where(type_sign: 2).find_all{ |x| x.faculty_id.nil? or x.faculty_id.to_i==current_user.faculty_id.to_i}.sort_by { |x| x.number.nil? ? 100: x.number} if [1,2,4,5,6].include?(@order.type_order)
  end

  def create
    @order = Order.new(order_params)
    @order.faculty_id=@order.pay_category_to_semester.faculty_id
    @order.year=year_today
    @order.semester=sem_today
    @order.status=0
    @order.up=""
    @order.bottom=""
    @order.signature=""
    if @order.save
      @signature=Signature.where(type_sign: 1).find_all{ |x| x.faculty_id.nil? or x.faculty_id.to_i==current_user.faculty_id.to_i}.sort_by { |x| x.number.nil? ? 100: x.number} if [0,3,7].include?(@order.type_order)
      @signature=Signature.where(type_sign: 2).find_all{ |x| x.faculty_id.nil? or x.faculty_id.to_i==current_user.faculty_id.to_i}.sort_by { |x| x.number.nil? ? 100: x.number} if [1,2,4,5,6].include?(@order.type_order)
      render action: 'edit'
    else
      render 'new'
    end
  end

  def update
    #@order = Order.find(params[:id])
    #raise params[:order][:list].inspect
    if @order.signature.nil? or @order.signature.empty?
      @order.signature=""
      arr=Array.new(params[:order][:list].size+1)

      if [0,3,7].include?(@order.type_order)
        for i in 0...params[:order][:list].size
          unless params[:order][:list][i.to_s].nil? or params[:order][:list][i.to_s]["id"]==""
            arr[params[:order][:list][i.to_s]["id"].to_i]=params[:order][:list][i.to_s]["name1"].to_s+"\t"+params[:order][:list][i.to_s]["name2"].to_s+"\n"
          end
        end
      end

      if [1,2,4,5,6].include?(@order.type_order)
        for i in 0...params[:order][:list].size
          unless params[:order][:list][i.to_s].nil? or params[:order][:list][i.to_s]["id"]==""
            arr[params[:order][:list][i.to_s]["id"].to_i]=params[:order][:list][i.to_s]["name1"].to_s+"\n"
          end
        end
      end

      for i in 0...arr.size
        @order.signature+=arr[i] unless arr[i].nil?
      end
      # raise @order.bottom.inspect
    end

    if @order.update(order_params)
      redirect_to action: 'index'
    else
      render action: 'edit'
    end

  end

  def destroy
    #@order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path
  end

private
  def order_params
    params.require(:order).permit(:number,:status, :type_order,:year,:semester,:date,:up,:signature,:bottom,:pay_category_to_semester_id)
  end

  def correct_faculty
    @order = Order.includes(:pay_category_to_semester).find(params[:id])
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all' || @order.faculty_id == current_user.faculty_id
  end
end
