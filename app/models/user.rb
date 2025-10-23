class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  belongs_to :office
  belongs_to :team
  validates :name, presence: true
  validates :account_status, presence: true
  enum :account_status, { active: 0, inactive: 1 }
end
