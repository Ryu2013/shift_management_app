class Client < ApplicationRecord
  belongs_to :office
  belongs_to :team
end
