# app/forms/user_webhook_params.rb
class UserWebhookParams
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email, :name, :role, :password, :password_confirmation

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[employee hr manager admin] }

  def attributes
    {
      email: email,
      name: name,
      role: role
    }
  end
end
