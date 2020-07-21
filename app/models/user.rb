class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_numericality_of :zip
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates_presence_of :role

  has_secure_password

  enum role: [:regular, :merchant_employee, :admin]
end
