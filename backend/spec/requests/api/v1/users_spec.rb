require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:admin_user) { create(:user, role: :admin, password: 'password123') }
  let(:valid_params) do
    {
      user: {
        email: 'john@example.com',
        name: 'John Doe',
        role: 'employee'
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: '',
        name: 'John Doe',
        role: 'employee'
      }
    }
  end

  before do
    post '/auth/sign_in', params: { email: admin_user.email, password: 'password123' }
    @auth_headers = {
      'Authorization' => response.headers['Authorization'],
      'Content-Type' => 'application/json'
    }
  end

  describe 'POST /api/v1/users' do
    context 'with valid parameters' do
      it 'creates a new user and returns created status' do
        expect {
          post '/api/v1/users', params: valid_params.to_json, headers: @auth_headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['id']).to be_present
        expect(json['message']).to eq('User created')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns errors' do
        post '/api/v1/users', params: invalid_params.to_json, headers: @auth_headers

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank")
      end
    end

    context 'with pagination and filtering' do
      let!(:authenticated_user) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:auth_headers) { authenticated_user.create_new_auth_token }

      it 'returns a list of users with pagination meta' do
        get '/api/v1/users', headers: auth_headers.merge('ACCEPT' => 'application/json')

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)

        expect(json).to have_key('data')
        expect(json).to have_key('meta')

        expect(json['data'].size).to eq(5)

        expect(json['meta']).to include('current_page', 'total_pages', 'total_entries', 'per_page')
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    let!(:target_user) { create(:user) }

    it 'deletes the user if admin' do
      delete "/api/v1/users/#{target_user.id}", headers: @auth_headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['message']).to eq('User deleted')
      expect(User.exists?(target_user.id)).to be_falsey
    end
  end

  describe 'PATCH /api/v1/users/:id/inactivate' do
    let!(:target_user) { create(:user) }

    it 'inactivates the user if admin' do
      patch "/api/v1/users/#{target_user.id}/inactivate", headers: @auth_headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['message']).to eq('User inactivated')
      expect(target_user.reload.status).to eq('inactive')
    end
  end
end
