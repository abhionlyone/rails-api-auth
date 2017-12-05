module Api
  module V1
    class ApiController < ActionController::API
      include Concerns::Authenticator
      include Concerns::ErrorHandler


    end
  end
end
