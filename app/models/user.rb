class User < ApplicationRecord
  devise :invitable, :registerable,
         :validatable, :confirmable, :lockable, :two_factor_authenticatable

  encrypts :otp_secret

  belongs_to :office
  belongs_to :team
  has_many :clients, through: :user_clients
  has_many :user_clients, dependent: :destroy
  has_many :shifts, dependent: :nullify
  has_many :user_needs, dependent: :destroy
  validates :name, presence: true
  validates :account_status, presence: true
  enum :account_status, { active: 0, inactive: 1 }
  enum :role, { employee: 0, admin: 1 }
end
