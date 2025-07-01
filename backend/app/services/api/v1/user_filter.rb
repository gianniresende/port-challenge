module Api
  module V1
    class UserFilter < ApplicationService

      def initialize(params:)
        @params = params
      end

      def call
        Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          scoped_users
        end
      end

      private
      def scoped_users
        User
          .by_name(@params[:name])
          .by_email(@params[:email])
          .by_role(@params[:role])
          .by_status(@params[:status])
          .ordered_by(@params[:order_by], @params[:direction])
          .paginate(page: @params[:page], per_page: @params[:per_page])
      end
      def cache_key
        [
          'users/index',
          @params[:page] || 1,
          @params[:per_page] || 10,
          @params[:name],
          @params[:email],
          @params[:role],
          @params[:status],
          @params[:order_by],
          @params[:direction],
          User.maximum(:updated_at)&.to_i
        ].join('-')
      end
    end
  end
end
