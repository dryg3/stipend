module SessionsHelper
  def year_today
  @year_today="2014/2015"
  end
  def sem_today
    @sem_today=1
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
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.includes(:faculty,:roles).find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

end
