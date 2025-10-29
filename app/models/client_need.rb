class ClientNeed < ApplicationRecord
  belongs_to :office
  belongs_to :client
  before_validation :set_office_id

  validates :shift_type, :week, :start_time, :end_time, :slots, presence: true

  enum shift_type: { day: 0, night: 1 }
  enum week: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  after_create_commit  -> { broadcast_append_to  stream_key, target: "client_needs_#{week}" }
  after_update_commit  -> { broadcast_replace_to stream_key }
  after_destroy_commit -> { broadcast_remove_to  stream_key }

  private
  def set_office_id
    self.office_id = client.office_id
  end

  def stream_key = [ client.team, :client_needs ]
end
