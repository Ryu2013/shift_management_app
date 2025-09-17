class MailLog < ApplicationRecord
  belongs_to :office
  belongs_to :employee

  has_many :mail_recipients, dependent: :destroy
end
