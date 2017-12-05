module Api
  module V1
    module Concerns
      module Authenticator
        extend ActiveSupport::Concern

        included do
          before_action :auth_with_token!, :correct_secret_api_key?
        end

        def current_user
          @current_user ||=
            User.find_by(auth_token: request.headers['X-Auth-Token'])
        end

        def user_signed_in?
          current_user.present?
        end

        def auth_with_token!
          head :unauthorized unless user_signed_in?
        end

        def correct_secret_api_key?
          head :unauthorized unless request.headers['Authorization'] == ENV['SECRET_API_KEY']
        end
        
      end
    end
  end
end
