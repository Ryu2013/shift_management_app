class User < ApplicationRecord
  devise :invitable, :registerable,
         :validatable, :confirmable, :lockable, :two_factor_authenticatable
  devise :pwned_password unless Rails.env.test?
  encrypts :otp_secret

  belongs_to :office
  belongs_to :team
  has_many :clients, through: :user_clients
  has_many :user_clients, dependent: :destroy
  has_many :shifts, dependent: :nullify
  has_many :user_needs, dependent: :destroy
  validates :name, presence: true
  enum :role, { employee: 0, admin: 1 }
end
