class SessionsController < ApplicationController

  def new
    if already_logged_in?
      flash[:notice] = "You are already logged in."
      redirect_logged_in(current_user)
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in!"
      redirect_logged_in(user)
    else
      flash[:error] = 'Wrong email or password entered - please try logging in again.'
      render :new
    end
  end

  private

  def redirect_logged_in(user)
    if user.regular?
      redirect_to '/profile'
    elsif user.merchant_employee?
      redirect_to '/merchant/dashboard'
    elsif user.admin?
      redirect_to '/admin/dashboard'
    end
  end

  def regular_user_logged_in?
    current_user && current_user.regular?
  end

  def merchant_employee_logged_in?
    current_user && current_user.merchant_employee?
  end

  def admin_logged_in?
    current_user && current_user.admin?
  end

  def already_logged_in?
    regular_user_logged_in? || merchant_employee_logged_in? || admin_logged_in?
  end
end
