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
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
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
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.includes(:faculty)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :tel, :password, :password_confirmation)
  end

  def correct_user
    @user = User.includes(:roles,:faculty).find(params[:id])
    redirect_to(users_url) unless current_user?(@user) || current_user.faculty.name == "all"
  end

  def correct_faculty
    redirect_to help_url, notice: 'Доступ запрещен' unless current_user.faculty.name == 'all'
  end
end
