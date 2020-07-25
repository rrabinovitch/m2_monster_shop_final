class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :user
  # refactor later to keep either `current_user` OR `user`

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user
    if session[:user_id] != nil
      @user = User.find(session[:user_id])
    end
  end

  def require_authorized_user
    render file: "/public/404" if unauthorized_user?
  end

  # This is same as line 10 `def user` - refactor later
  def logged_in_user
    @logged_in_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
