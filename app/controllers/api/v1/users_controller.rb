module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_webhook!, only: [:create]
      def create
        result = UserCreationService.call(user_params)

        if result.success
          render json: { id: result.user.id, message: 'User created' }, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :name, :role)
      end

    end
  end
end
