class Profile::PasswordsController < ApplicationController
  def edit
  end

  def update
    if passwords_empty?
      flash[:error] = "Password and/or confirm password field cannot be empty."
      redirect_to "/profile/password/edit"
    elsif passwords_match?
      current_user.update(password_update_params)
      flash[:success] = "Your password has been changed."
      redirect_to "/profile"
    else
      flash[:error] = "Passwords do not match."
      redirect_to "/profile/password/edit"
    end
  end

  private
  def passwords_match?
    params[:password] == params[:confirm_password]
  end

  def passwords_empty?
    params[:password].empty? || params[:confirm_password].empty?
  end

  def password_update_params
    params.permit(:password)
  end
end
