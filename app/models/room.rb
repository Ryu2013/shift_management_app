class Room < ApplicationRecord
  belongs_to :office
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy
end
