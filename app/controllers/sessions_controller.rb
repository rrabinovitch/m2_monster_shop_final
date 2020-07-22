class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in!"
      if user.role == "regular"
        redirect_to '/profile'
      elsif user.role == "merchant_employee"
        redirect_to '/merchant/dashboard'
      elsif user.role == "admin"
        redirect_to '/admin/dashboard'
      end
    else
      flash[:error] = 'Wrong email or password entered - please try logging in again.'
      render :new
    end
  end
end
