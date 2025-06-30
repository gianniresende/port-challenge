require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:admin_user) { create(:user, role: :admin, password: 'password123') }
  let(:valid_params) do
    {
      user: {
        email: 'john@example.com',
        name: 'John Doe',
        role: 'employee'  # use uma role válida
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: '',  # email inválido para falha
        name: 'John Doe',
        role: 'employee'
      }
    }
  end

  before do
    # Faz login para obter os headers necessários
    post '/auth/sign_in', params: { email: admin_user.email, password: 'password123' }
    @auth_headers = {
      'access-token' => response.headers['access-token'],
      'client' => response.headers['client'],
      'uid' => response.headers['uid'],
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
  end
end
