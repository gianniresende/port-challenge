module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      before_action :authenticate_any!

      private

      def authenticate_any!
        authenticate_user_from_token || authenticate_user!

        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
      end

      def authenticate_user_from_token
        token = request.headers['Authorization']&.split(' ')&.last
        api_token = ApiToken.find_by(token: token)

        if api_token
          api_token.update(last_used_at: Time.current)
          @current_user = api_token.user
        end
      end

      def current_user
        super || @current_user
      end

      def pundit_user
        current_user
      end
    end
  end
end
