class ContactStatus < ApplicationRecord
  belongs_to :office
  belongs_to :shift_member
  belongs_to :employee
end
