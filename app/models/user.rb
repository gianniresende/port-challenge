class User < ApplicationRecord
	# Include default devise modules.
	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :validatable, :omniauthable
	include DeviseTokenAuth::Concerns::User

	validates :name, presence: true
  validates :role, presence: true

	enum role: { employee: 0, hr: 1, manager: 2, admin: 3 }
	enum status: { active: 0, inactive: 1 }

	before_validation :set_password, on: :create
  before_validation :set_uid, on: :create

	scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :by_email, ->(email) { where("email ILIKE ?", "%#{email}%") if email.present? }
  scope :by_role, ->(role) { where(role: role) if role.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :ordered_by, ->(field, direction = 'asc') {
    allowed_fields = %w[name email created_at]
    allowed_directions = %w[asc desc]

    if allowed_fields.include?(field.to_s) && allowed_directions.include?(direction.to_s)
      order("#{field} #{direction}")
    else
      all
    end
  }

  private

  def set_password
    # Only set password if not already set (ex: webhook creation)
    self.password ||= Devise.friendly_token[0, 20]
  end

  def set_uid
    self.uid = email if uid.blank? && email.present?
  end
end
