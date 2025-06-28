# app/forms/user_webhook_params.rb
class UserWebhookParams
  include ActiveModel::Model

  attr_accessor :email, :name, :role

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[user admin] }

  def attributes
    {
      email: email,
      name: name,
      role: role
    }
  end
end
