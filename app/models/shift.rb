class Shift < ApplicationRecord
  belongs_to :office
  belongs_to :client
  validates :start_time, :end_time, presence: true
end
