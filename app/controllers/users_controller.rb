class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :correct_faculty, except: [:show, :edit, :update]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Пользователь создан'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Пользователь изменен'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'Пользователь удален'
    redirect_to users_url
  end

  def index
    @users = User.includes(:faculty,:role)
  end

  private
  def user_params
    params.require(:user).permit(:surname, :firstname, :secondname, :login, :tel, :faculty_id, :role_id)
  end

  def correct_user
    @user = User.includes(:role,:faculty).find(params[:id])
  end

  def correct_faculty
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end
end
