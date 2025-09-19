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
  accepts_nested_attributes_for :employee_needs, allow_destroy: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :name, presence: true
  validates :pending_office_name, presence: true, if: -> { office_id.nil? }
  validate :pending_office_name_uniqueness, on: :create

  # メール確認URLクイック時、管理者のオフィスが未登録ならオフィス登録、既存ならログインページへ
  def after_confirmation
    return if office_id.present?
    return if pending_office_name.blank?

    normalized_name = pending_office_name.strip

    Office.transaction do
      created_office = Office.create!(name: normalized_name)
      update!(office: created_office, pending_office_name: nil)
    end

    Employees::LoginMailer.with(employee: self).login_link.deliver_later
  end

  private

  def pending_office_name_uniqueness
    return if pending_office_name.blank?

    normalized_name = pending_office_name.strip
    if Office.exists?(name: normalized_name)
      errors.add(:pending_office_name, 'は既に登録されています。管理者に確認してください。')
    end
  end

end
