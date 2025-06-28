class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

	rescue_from StandardError do |exception|
    if exception.message =~ /Unauthorized/
      render json: { errors: ['Unauthorized'] }, status: :unauthorized
    else
      raise exception
    end
  end
end
