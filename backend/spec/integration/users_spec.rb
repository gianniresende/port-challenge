require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users' do
    get 'Lista usuários' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'usuários encontrados' do
        let(:user) { create(:user, password: 'password123') }

        before do
          post '/auth/sign_in', params: {
            email: user.email,
            password: 'password123'
          }, as: :json

          @auth_token = response.headers['Authorization']
        end

        let(:Authorization) { @auth_token }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/inactivate' do
    patch 'Inativa um usuário' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'ID do usuário a ser inativado'

      response '200', 'usuário inativado com sucesso' do
        let(:user) { create(:user, password: 'password123') }

        before do
          post '/auth/sign_in', params: {
            email: user.email,
            password: 'password123'
          }, as: :json

          @auth_token = response.headers['Authorization']
        end

        let(:Authorization) { @auth_token }
        let(:id) { user.id }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    delete 'Exclui um usuário' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :id, in: :path, type: :integer, description: 'ID do usuário a ser excluído'

      response '204', 'usuário excluído com sucesso' do
        let(:user) { create(:user, password: 'password123') }

        before do
          post '/auth/sign_in', params: {
            email: user.email,
            password: 'password123'
          }, as: :json

          @auth_token = response.headers['Authorization']
        end

        let(:Authorization) { @auth_token }
        let(:id) { user.id }

        run_test!
      end

      response '404', 'usuário não encontrado' do
        let(:Authorization) { 'Bearer token_valido' }
        let(:id) { 0 }

        run_test!
      end

      response '401', 'não autorizado' do
        let(:id) { create(:user).id }
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end