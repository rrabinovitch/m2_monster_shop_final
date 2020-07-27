class PasswordsController < ApplicationController
  def edit
  end

  def update
    flash[:success] = "Your password has been changed."
    redirect_to "/profile"
  end
end
