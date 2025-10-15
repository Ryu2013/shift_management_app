class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :use
end
