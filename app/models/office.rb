class Office < ApplicationRecord
    validates :name, presence: true
    has_many :users, dependent: :destroy
    has_many :shifts, dependent: :destroy
    has_many :clients, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :user_clients, dependent: :destroy
    has_many :client_needs, dependent: :destroy
    has_many :rooms, dependent: :destroy
    has_many :entries, through: :rooms
    has_many :messages, through: :rooms

  def subscription_active?
    return false unless subscription_status.present?

    if [ "active", "trialing", "past_due" ].include?(subscription_status)
      return true
    end

    false
  end
end
