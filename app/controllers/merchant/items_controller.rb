class Merchant::ItemsController < ApplicationController
  before_action :require_authorized_user

  def index
    @merchant_employee = User.find(current_user.id)
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end
end
