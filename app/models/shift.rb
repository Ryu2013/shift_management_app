class Shift < ApplicationRecord
  belongs_to :office
  belongs_to :client
  belongs_to :user, optional: true
  validates :start_time, :end_time, presence: true
  validates :date, presence: true
  enum :shift_type, { day: 0, night: 1, escort: 2 }
  enum :work_status, { not_work: 0, work: 1 }

  scope :scope_month, ->(month) { where(date: month.beginning_of_month..month.end_of_month) }

  after_create_commit  -> { broadcast_append_to  stream_key, target: "shifts_#{date}" }
  after_update_commit  -> { broadcast_replace_to stream_key }
  after_destroy_commit -> { broadcast_remove_to  stream_key }

  private

  def stream_key = [ client.team, :shifts ]
end
