class SessionsController < ApplicationController

  def new
    # if current_user.regular?
    #   redirect_to ...
    # elsif ...
    # end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil?
      flash[:error] = 'Wrong email or password entered - please try logging in again.'
      render :new
    elsif user.authenticate(params[:password]) # look into whether username/email can be authenticated similarly to password authentication
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
    # consider DRYer way to implement sad path logic

    # if user && user.authenticate(...)
    #  happy path code
    # else
    #  sad path code
    # end
  end
end
