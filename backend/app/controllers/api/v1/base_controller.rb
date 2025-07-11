module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      before_action :authenticate_any!

      private

      def authenticate_any!
        return if authenticate_user_from_token || current_user.present?

        render json: { error: 'Unauthorized' }, status: :unauthorized
      end



      def authenticate_user_from_token
        token = request.headers['X-Api-Token']&.split(' ')&.last
        api_token = ApiToken.find_by(token: token)

        if api_token
          api_token.update(last_used_at: Time.current)
          @current_user = api_token.user
          return true
        end

        false
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
