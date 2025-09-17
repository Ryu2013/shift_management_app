class ClientNeed < ApplicationRecord
  belongs_to :office
  belongs_to :client

  validates :week, :start_time, :end_time, :slots, presence: true
end
