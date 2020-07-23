class SessionsController < ApplicationController

  def new
    if current_user && current_user.regular?
      redirect_to '/profile'
      flash[:notice] = "You are already logged in."
    elsif current_user && current_user.merchant_employee?
      redirect_to '/merchant/dashboard'
      flash[:notice] = "You are already logged in."
    elsif current_user && current_user.admin?
      redirect_to '/admin/dashboard'
      flash[:notice] = "You are already logged in."
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
end
