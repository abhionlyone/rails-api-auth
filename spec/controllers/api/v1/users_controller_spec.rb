require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create :user }
  let(:user_params) { attributes_for :user }
  before(:each) do
    ENV['SECRET_API_KEY'] = 'SECRET_API_KEY'
  end

  describe 'POST /api/v1/users #create' do

    context 'without a valid secret key in header' do
      it 'returns HTTP status 401' do
        request.headers.merge!({ 'Accept': 'application/vnd' })
        post :create, params: user_params
        expect(response).to have_http_status 401
      end
    end

    context 'with a valid secret key in header' do
      it 'returns HTTP status 201 with unique email and valid password' do
        request.headers.merge!({ 'Accept': 'application/vnd', 'Authorization': 'SECRET_API_KEY' })
        post :create, params: {user: user_params}
        body = JSON.parse(response.body)
        expect(response).to have_http_status 201
        expect(body['email']).to eq(user_params[:email])
        expect(body['auth_token']).to_not be_nil
      end

      it 'returns HTTP status 422 with existing email' do
        request.headers.merge!({ 'Accept': 'application/vnd', 'Authorization': 'SECRET_API_KEY' })
        post :create, params: {user: user_params}
        body = JSON.parse(response.body)
        duplicated_params = {email: body['email'], password: '12345678'}
        post :create, params: {user: duplicated_params}
        body = JSON.parse(response.body)
        expect(response).to have_http_status 422
      end
    end

  end

end
