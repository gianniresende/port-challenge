class ApiToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true

  before_validation :generate_secure_token, on: :create
  before_create :set_last_used_at

  private

  def generate_secure_token
    self.token ||= SecureRandom.hex(32)
  end

  def set_last_used_at
    self.last_used_at = Time.current
  end
end
