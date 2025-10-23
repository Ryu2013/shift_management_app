class Shift < ApplicationRecord
  belongs_to :office
  belongs_to :client
  validates :start_time, :end_time, presence: true
  validates :date, presence: true
  enum :shift_type, { day: 0, night: 1 }

  scope :scope_month, ->(month) { where(date: month.beginning_of_month..month.end_of_month) }

end
