require 'rails_helper'

RSpec.describe UserWebhookParams do
  describe '#valid?' do
    context 'with valid params' do
      let(:params) { { email: 'test@example.com', name: 'Test', role: 'user' } }

      it 'is valid' do
        form = described_class.new(params)
        expect(form).to be_valid
      end
    end

    context 'with missing email' do
      let(:params) { { name: 'Test', role: 'user' } }

      it 'is not valid and adds error to email' do
        form = described_class.new(params)
        expect(form).not_to be_valid
        expect(form.errors[:email]).to include("can't be blank")
      end
    end
  end

  describe '#attributes' do
    it 'returns a hash with permitted attributes' do
      form = described_class.new(email: 'a@example.com', name: 'A', role: 'user')
      expect(form.attributes).to eq(email: 'a@example.com', name: 'A', role: 'user')
    end
  end
end
