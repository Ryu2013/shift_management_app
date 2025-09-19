class EmployeeNeed < ApplicationRecord
  belongs_to :office
  belongs_to :employee

  validates :week, :start_time, :end_time, presence: true

  before_validation :sync_office

  private

  def sync_office
    self.office ||= employee&.office
  end
end
