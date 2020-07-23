class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def index
  end

  def require_authorized_user
    render file: "/public/404" if unauthorized_user?
  end

  def logged_in_user
    User.find(session[:user_id]) if session[:user_id]
  end
end
