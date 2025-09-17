class MailRecipient < ApplicationRecord
  belongs_to :office
  belongs_to :mail_log
  belongs_to :employee
end
