module Api
  module V1
    class UserFilter
      def self.call(params)
        User
          .by_name(params[:name])
          .by_email(params[:email])
          .by_role(params[:role])
          .by_status(params[:status])
          .ordered_by(params[:order_by], params[:order])
          .paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
      end
    end
  end
end
