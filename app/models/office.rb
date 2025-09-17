class Office < ApplicationRecord
  has_many :employees, dependent: :nullify
  has_many :teams, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :client_needs, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :shift_members, dependent: :destroy
  has_many :contact_statuses, dependent: :destroy
  has_many :mail_logs, dependent: :destroy
  has_many :mail_recipients, dependent: :destroy
  has_many :employee_clients, dependent: :destroy
  has_many :employee_needs, dependent: :destroy

  before_validation :ensure_slug

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  private

  def ensure_slug
    base = (slug.presence || name.to_s).parameterize
    base = "office" if base.blank?
    candidate = base
    counter = 2
    while Office.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
