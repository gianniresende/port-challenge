# spec/services/api/v1/user_creation_service_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UserCreationService do
  describe '.call' do
    context 'when valid parameters' do
      let(:valid_params) { attributes_for(:user) }

      it 'creates a user successfully' do
        params = { email: 'user@example.com', name: 'User', role: 'user' }
        result = Api::V1::UserCreationService.call(params)
        expect(result.success).to be true
      end
    end

    context 'when invalid parameters' do
      let(:invalid_params) { attributes_for(:user, email: '') }

      it 'returns failure with errors' do
        result = described_class.call(invalid_params)

        expect(result.success).to be false
        expect(result.user).to be_nil
        expect(result.errors).to include("Email can't be blank")
      end
    end
  end
end
