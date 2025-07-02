# spec/integration/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'Authentication', type: :request do
  path '/auth/sign_in' do
    post 'Login com sucesso' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response '200', 'Login bem-sucedido' do
        let(:user) { create(:user, password: 'password123') }
        let(:credentials) { { email: user.email, password: 'password123' } }

        run_test! do |response|
          expect(response.headers['Authorization']).to be_present
        end
      end
    end
  end
end

