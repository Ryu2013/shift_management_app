class Client < ApplicationRecord
  belongs_to :office
  belongs_to :team
  has_many :shifts, dependent: :destroy
end
