class Team < ApplicationRecord
  belongs_to :office
  has_many :clients, dependent: :nullify
  has_many :users, dependent: :nullify

  validates :name, presence: true
end
