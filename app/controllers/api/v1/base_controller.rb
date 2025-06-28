module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_webhook!

      private

      def authenticate_webhook!
        token = request.headers['Authorization']&.split(' ')&.last
        unless ActiveSupport::SecurityUtils.secure_compare(token.to_s, ENV['WEBHOOK_SECRET'].to_s)
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end
