require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  let(:valid_token)   { 'supersecrettoken' }
  let(:invalid_token) { 'wrongtoken' }

  before do
    stub_const('ENV', ENV.to_hash.merge('WEBHOOK_SECRET' => valid_token))
  end

  describe 'POST /api/v1/users' do
    let(:headers_with_valid_token) do
      { 'Authorization' => "Bearer #{valid_token}" }
    end

    let(:headers_with_invalid_token) do
      { 'Authorization' => "Bearer #{invalid_token}" }
    end

    it 'returns 401 without Authorization header' do
      post '/api/v1/users'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 with invalid token' do
      post '/api/v1/users', headers: headers_with_invalid_token
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns success with valid token' do
      post '/api/v1/users', headers: headers_with_valid_token
      expect(response).not_to have_http_status(:unauthorized)
    end
  end
end
