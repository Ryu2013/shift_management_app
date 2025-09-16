class ShiftMember < ApplicationRecord
  belongs_to :office
  belongs_to :shift
  belongs_to :employee
end
