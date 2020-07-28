class Admin::UsersController < ApplicationController
  before_action :require_authorized_user

  def show
    @user = User.find(params[:id])
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.merchant_employee?
  end
end
