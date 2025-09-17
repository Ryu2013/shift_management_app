class ShiftMember < ApplicationRecord
  belongs_to :office
  belongs_to :shift
  belongs_to :employee

  has_many :contact_statuses, dependent: :destroy
end
