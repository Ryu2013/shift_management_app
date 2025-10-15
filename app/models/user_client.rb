class UserClient < ApplicationRecord
  belongs_to :office
  belongs_to :user
  belongs_to :client
end
