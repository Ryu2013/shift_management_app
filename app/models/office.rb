class Office < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :users, dependent: :destroy
    has_many :shifts, through: :clients
    has_many :clients, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :user_clients, dependent: :destroy
    has_many :user_needs, dependent: :destroy
    has_many :client_needs, dependent: :destroy


    accepts_nested_attributes_for :teams
end
