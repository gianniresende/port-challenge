module Api
  module V1
    class UserCreationService
      Result = Struct.new(:success, :user, :errors)

      def self.call(params)
        user = User.new(params)

        if user.save
          Result.new(true, user, nil)
        else
          Result.new(false, nil, user.errors.full_messages)
        end
      end
    end
  end
end
