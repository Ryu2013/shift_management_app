class Office < ApplicationRecord
  has_many :employees, dependent: :nullify
  has_many :teams, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :client_needs, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :shift_members, dependent: :destroy
  has_many :contact_statuses, dependent: :destroy
  has_many :mail_logs, dependent: :destroy
  has_many :mail_recipients, dependent: :destroy
  has_many :employee_clients, dependent: :destroy
  has_many :employee_needs, dependent: :destroy
end
