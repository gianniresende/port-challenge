module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!

      def index
        users = UserFilter.call(params)
        render json: UserSerializer.new(users).serializable_hash.merge(
          meta: {
            current_page: users.current_page,
            total_pages: users.total_pages,
            total_entries: users.total_entries,
            per_page: users.per_page
          }
        )
      end
      def create
        authorize User

        result = UserCreation.call(user_params)

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
