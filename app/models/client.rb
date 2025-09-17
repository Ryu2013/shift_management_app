class Client < ApplicationRecord
  belongs_to :office
  belongs_to :team

  has_many :client_needs, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :employee_clients, dependent: :destroy
  has_many :employees, through: :employee_clients
end
