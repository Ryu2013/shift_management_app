class Employee < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :team, optional: true

  has_many :shift_members, dependent: :destroy
  has_many :contact_statuses, dependent: :destroy
  has_many :employee_clients, dependent: :destroy
  has_many :clients, through: :employee_clients
  has_many :mail_logs, dependent: :destroy
  has_many :mail_recipients, dependent: :destroy
  has_many :employee_needs, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :name, presence: true
  validates :pending_office_name, presence: true, if: -> { office_id.nil? }

  def after_confirmation
    return if office_id.present?
    return if pending_office_name.blank?

    Office.transaction do
      created_office = Office.create!(name: pending_office_name)
      update!(office: created_office, pending_office_name: nil)
    end
  end
end
