class Merchant::DashboardController < ApplicationController
  before_action :require_authorized_user

  def index
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end
end
