class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :office
  validates :name, presence: true
  validates :account_status, presence: true
  enum account_status: { active: 0, inactive: 1 }
end
