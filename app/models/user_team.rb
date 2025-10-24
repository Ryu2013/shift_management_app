class UserTeam < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :office
end
