class Office < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :users, dependent: :destroy
    has_many :shifts, dependent: :destroy
    has_many :clients, dependent: :destroy
    has_many :teams, dependent: :destroy
end
