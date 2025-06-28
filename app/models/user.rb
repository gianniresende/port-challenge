class User < ApplicationRecord
	# Include default devise modules.
	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :trackable, :validatable,
					:omniauthable
	include DeviseTokenAuth::Concerns::User

	validates :name, presence: true
  validates :role, presence: true

	enum role: { user: 0, admin: 1 }
	enum status: { active: 0, inactive: 1 }

	before_validation :set_password, on: :create
  before_validation :set_uid, on: :create

  private

  def set_password
    # Only set password if not already set (ex: webhook creation)
    self.password ||= Devise.friendly_token[0, 20]
  end

  def set_uid
    self.uid = email if uid.blank? && email.present?
  end
end
