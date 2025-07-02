module Api
  module V1
    class UserCreation < ApplicationService
      def initialize(params:)
        @params = params
      end
      def call
        params_object = UserWebhookParams.new(@params)

        unless params_object.valid?
          return Result.new(false, nil, params_object.errors.full_messages)
        end

        user = User.new(params_object.attributes)

        if user.save
          Rails.logger.debug("User creation failed: #{user.errors.full_messages.join(', ')}")
          Result.new(success: true, user: user)
        else
          Result.new(success: false, errors: user.errors.full_messages)
        end
      end
    end
  end
end
