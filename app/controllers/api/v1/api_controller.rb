module Api
  module V1
    class ApiController < ActionController::API
      include ::ActionController::Serialization
      include Concerns::Authenticator
      include Concerns::ErrorHandler
      protect_from_forgery with: :exception


    end
  end
end
