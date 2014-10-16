class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include FacultiesHelper

  before_filter :cas_filter

  private
  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end

end
