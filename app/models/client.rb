class Client < ApplicationRecord
  belongs_to :office
  belongs_to :team
  has_many :shifts, dependent: :destroy
  has_many :client_needs, dependent: :destroy
  has_many :user_clients, dependent: :destroy
  accepts_nested_attributes_for :user_clients, allow_destroy: true
  has_many :users, through: :user_clients
  validates :name, presence: true
end
