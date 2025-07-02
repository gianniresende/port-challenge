module Api
  module V1
    class UserFilter < ApplicationService

      def initialize(params:)
        @params = params
      end

      def call
        Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          begin
            users = scoped_users
            serialized = UserSerializer.new(users).serializable_hash.merge(
              meta: {
                current_page: users.current_page,
                total_pages: users.total_pages,
                total_entries: users.total_entries,
                per_page: users.per_page
              }
            )

            Result.new(success: true, user: serialized)
          rescue StandardError => e
            Rails.logger.error("UserFilter error: #{e.class} - #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))

            Result.new(success: false, errors: [e.message])
          end
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
