module Api
  module V1
    class BaseController < ApplicationController
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def user_not_authorized
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end
  end
end
