module Api
  module V1
    class UserCreation
      Result = Struct.new(:success, :user, :errors)

      def self.call(params)
        params_object = UserWebhookParams.new(params)

        unless params_object.valid?
          return Result.new(false, nil, params_object.errors.full_messages)
        end

        user = User.new(params_object.attributes)

        if user.save
          Rails.logger.debug("User creation failed: #{user.errors.full_messages.join(', ')}")
          Result.new(true, user, nil)
        else
          Result.new(false, nil, user.errors.full_messages)
        end
      end
    end
  end
end
