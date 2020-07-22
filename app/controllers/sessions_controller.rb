class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id
    flash[:success] = "You are now logged in!"
    if user.role == "regular"
      redirect_to '/profile'
    elsif user.role == "merchant_employee"
      redirect_to 'merchant/dashboard'
    elsif user.role == "admin"
      redirect_to '/admin/dashboard'
    end
  end
end
