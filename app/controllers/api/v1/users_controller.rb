module Api
  module V1
    class UsersController < ApiController
      skip_before_action :auth_with_token!, only: [:create, :reset_password]

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render_error(user.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def forgot_password
        user = User.find_by_email(user_params[:email])
        if user
          user.send_password_reset_email
          render json: { message: I18n.t('reset_password.sent') }, status: :accepted
        else
          render_error(I18n.t('errors.messages.user_not_found'), :not_found)
        end
      end

      def new_password
        user = User.find_by_reset_password_token(params[:reset_password_token])
        if user && params[:reset_password_token]
          user.update_attributes(password: user_params[:password])
          user.save!
          puts user.errors.full_messages
          render json: { message: I18n.t('reset_password.success') }, status: :accepted
        else
          render_error(I18n.t('errors.messages.user_not_found'), :not_found)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
