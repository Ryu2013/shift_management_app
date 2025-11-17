class UserClient < ApplicationRecord
  belongs_to :office
  belongs_to :user
  belongs_to :client
  before_validation :set_office_id
  validates :user_id, uniqueness: { scope: :client_id }

  after_create_commit  -> { broadcast_append_to  stream_key if stream_key }
  after_update_commit  -> { broadcast_replace_to stream_key if stream_key }
  after_destroy_commit -> { broadcast_remove_to  stream_key if stream_key }

  private
    def set_office_id
    self.office_id ||= client&.office_id || user&.office_id
    end

    def stream_key = [ client&.team, :user_clients ]
end
