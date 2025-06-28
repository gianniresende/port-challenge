module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        user.password = Devise.friendly_token[0, 20] # senha aleatória
        user.uid = user.email

        if user.save
          render json: { id: user.id, message: 'User created' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :name, :role)
      end
    end
  end
end
