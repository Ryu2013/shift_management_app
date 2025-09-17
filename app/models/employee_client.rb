class EmployeeClient < ApplicationRecord
  belongs_to :office
  belongs_to :employee
  belongs_to :client

  validates :employee_id, uniqueness: { scope: [:office_id, :client_id] }
end
