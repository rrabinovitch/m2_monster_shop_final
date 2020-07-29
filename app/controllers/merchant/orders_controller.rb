class Merchant::OrdersController < ApplicationController
  before_action :require_authorized_user

  def show
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end
end
