class SessionsController < ApplicationController
  def new
  end


  def create
    user = User.includes(:role,:faculty).find_by(login: params[:session][:email].downcase)
    if user
      sign_in user
      redirect_to root_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
    sign_out
    redirect_to root_url
  end
end
