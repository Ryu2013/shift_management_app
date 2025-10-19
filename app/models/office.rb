class Office < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :team_name, presence: true, on: :create 
    has_many :users, dependent: :destroy
    has_many :shifts, dependent: :destroy
    has_many :clients, dependent: :destroy
    has_many :teams, dependent: :destroy
    attr_accessor :team_name

    after_create do
        teams.create!(name: team_name)
    end
end
