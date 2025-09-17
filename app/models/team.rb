class Team < ApplicationRecord
  belongs_to :office

  has_many :employees, dependent: :nullify
  has_many :clients, dependent: :nullify
end
