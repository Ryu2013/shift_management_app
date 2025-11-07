class UserNeed < ApplicationRecord
  belongs_to :office
  belongs_to :user
  before_validation :set_office_id

  validates :week, :start_time, :end_time, presence: true
  enum week: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  after_create_commit  -> { broadcast_append_to  stream_key, target: "user_needs_#{week}" }
  after_update_commit  -> { broadcast_replace_to stream_key }
  after_destroy_commit -> { broadcast_remove_to  stream_key }

  private
  def set_office_id
    self.office_id = user.office_id
  end

  def stream_key = [ user.team, :user_needs ]
end
