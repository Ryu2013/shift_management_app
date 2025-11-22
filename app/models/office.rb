class Office < ApplicationRecord
    validates :name, presence: true
    has_many :users, dependent: :destroy
    has_many :shifts, dependent: :destroy
    has_many :clients, dependent: :destroy
    has_many :teams, dependent: :destroy
    has_many :user_clients, dependent: :destroy
    has_many :user_needs, dependent: :destroy
    has_many :client_needs, dependent: :destroy
end
