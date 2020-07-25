class UsersController < ApplicationController
  def new
    @user = User.new(session[:user_registration_params])
    session.delete(:user_registration_params)
  end

  def create
    user = User.new(user_params)
    can_register?(user) ? register(user) : retry_registration(user)
  end

  def show
    render file: "/public/404" unless logged_in_user
  end

  private
  def passwords_match?
    params[:password] == params[:confirm_password]
  end

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def user_registration_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end

  def summarize_missing_details(user)
    user.errors.messages.map do |type, message|
      type.to_s.capitalize + " " + message.uniq.join
    end.join("\n")
  end

  def can_register?(user)
    user.valid? && passwords_match?
  end

  def register(user)
    user.save
    flash[:success] = "You are now registered and logged in!"
    redirect_to "/profile"
  end

  def retry_registration(user)
    flash[:failure] = "All fields must be completed before submitting:"
    flash[:missing_details] = summarize_missing_details(user)
    flash[:mismatched_passwords] = "Passwords do not match" unless passwords_match?

    session[:user_registration_params] = user_registration_params
    redirect_to register_path
  end
end
