module Mailers
  class WelcomeMailerJob < ApplicationJob
    queue_as :mailers

    def perform(user_id, password)
      user = User.find_by(id: user_id)
      return unless user

      UserMailer.send_welcome_email(user, password).deliver_now
    end
  end
end