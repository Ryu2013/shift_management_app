class Office < ApplicationRecord
    has_many :employees, dependent: :nullify
end
