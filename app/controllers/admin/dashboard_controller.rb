class Admin::DashboardController < ApplicationController
  before_action :require_authorized_user

  def index
  end

  private

  def unauthorized_user?
    logged_in_user.nil? || logged_in_user.regular? || logged_in_user.merchant_employee?
  end
end
