class Employee < ApplicationRecord
  belongs_to :office
  belongs_to :team, optional: true

  has_many :shift_members, dependent: :destroy
  has_many :contact_statuses, dependent: :destroy
  has_many :employee_clients, dependent: :destroy
  has_many :clients, through: :employee_clients
  has_many :mail_logs, dependent: :destroy
  has_many :mail_recipients, dependent: :destroy
  has_many :employee_needs, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
