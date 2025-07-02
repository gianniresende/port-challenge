require 'rails_helper'

RSpec.describe Api::V1::UserCreation do
  describe '.call' do
    context 'when valid parameters' do
      let(:valid_params) do
        {
          email: 'user@example.com',
          name: 'User',
          password: 'password123',
          role: 'employee'
        }
      end

      it 'creates a user successfully' do
        result = described_class.call(params: valid_params)

        expect(result.success).to be true
        expect(result.user).to be_a(User)
        expect(result.user.email).to eq(valid_params[:email])
        expect(result.errors).to be_empty
      end
    end

    context 'when invalid parameters' do
      let(:invalid_params) { { name: '', email: '', role: 'invalid_role' } }

      it 'returns failure with errors' do
        result = described_class.call(params: invalid_params)

        expect(result.success).to be false
        expect(result.user).to be_nil
        expect(result.errors).to be_an(Array)
        expect(result.errors).not_to be_empty
      end
    end
  end
end
