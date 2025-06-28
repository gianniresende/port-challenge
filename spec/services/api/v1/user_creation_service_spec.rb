# spec/services/api/v1/user_creation_service_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UserCreationService do
  describe '.call' do
    context 'when valid parameters' do
      let(:valid_params) { attributes_for(:user) }

      it 'creates a user successfully' do
        params = { email: 'user@example.com', name: 'User', role: 'employee' }
        result = Api::V1::UserCreationService.call(params)
         puts result.errors.inspect
        expect(result.success).to be true
      end
    end

    context 'when invalid parameters' do
      let(:invalid_params) { attributes_for(:user, email: '') }

      it 'returns failure with errors' do
        result = described_class.call(invalid_params)

        expect(result.user).to be_nil
        expect(result.success).to be false
      end
    end
  end
end
