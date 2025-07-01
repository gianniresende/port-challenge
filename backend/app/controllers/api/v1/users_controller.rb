module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!
      before_action :set_user, only: [:destroy, :inactivate]

      def index
        users = UserFilter.call(params: params)
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

      def destroy
        authorize @user
        @user.destroy
        render json: { message: 'User deleted' }, status: :ok
      end

      def inactivate
        authorize @user
        @user.inactivate!
        render json: { message: 'User inactivated' }, status: :ok
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
      def user_params
        params.require(:user).permit(:email, :name, :role)
      end
    end
  end
end
