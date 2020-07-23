class SessionsController < ApplicationController

  def new
    # if current_user.regular?
    #   redirect_to ...
    # elsif ...
    # end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are now logged in!"
      if user.regular?
        redirect_to '/profile'
      elsif user.merchant_employee?
        redirect_to '/merchant/dashboard'
      elsif user.admin?
        redirect_to '/admin/dashboard'
      end
    else
      flash[:error] = 'Wrong email or password entered - please try logging in again.'
      render :new
    end

    # if user && user.authenticate(...)
    #  happy path code
    # else
    #  sad path code
    # end
  end
end
