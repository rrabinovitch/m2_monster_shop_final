class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if passwords_match? && user.save
      flash[:success] = "You are now registered and logged in!"
      redirect_to "/profile"
    else
      missing_params = user_params.select { |_, param| param.empty? }
      missing_params = missing_params.keys.join(", ")
      missing_params = "confirm password" if missing_params.empty?
      flash[:failure] = "Please fill in the missing fields: #{missing_params}."
      redirect_to "/register"
    end
  end

  def show
  end

  private
  def passwords_match?
    params[:password] == params[:confirm_password]
  end

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
