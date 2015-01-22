module SessionsHelper
  def year_today
    @year_today='2014/2015'
  end

  def sem_today
    @sem_today=2
  end

  def year_previous(y)
    [3,8].each{|x| y[x]=(y[x].to_i-1).to_s}
    y
  end

  def sem_previous(s)
    (s+2)%2+1
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end



  def current_user
    remember_token = User.includes(:roles,:faculty).encrypt(cookies[:remember_token])
    @current_user ||= User.includes(:faculty,:roles).find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

end
