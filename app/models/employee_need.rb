class EmployeeNeed < ApplicationRecord
  belongs_to :office
  belongs_to :employee

  validates :week, :start_time, :end_time, presence: true
end
