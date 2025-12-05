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
    # 1. ステータスが空なら未契約
    return false unless subscription_status.present?

    # 2. Stripeが「active」または「trialing(お試し)」なら無条件でOK
    return true if ['active', 'trialing'].include?(subscription_status)

    # 3. 解約済み(canceled)でも、有効期限内ならOK
    if subscription_status == 'canceled' && current_period_end.present?
      return Time.current < current_period_end
    end

    # それ以外はNG
    false
  end
end
