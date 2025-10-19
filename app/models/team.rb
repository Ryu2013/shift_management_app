class Team < ApplicationRecord
  belongs_to :office
  has_many :clients, dependent: :destroy
  validates :name, presence: true
end
