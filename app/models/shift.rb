class Shift < ApplicationRecord
  belongs_to :office
  belongs_to :client

  has_many :shift_members, dependent: :destroy
  has_many :employees, through: :shift_members
  has_many :contact_statuses, through: :shift_members
end
