require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }

    it 'is invalid when token is not unique' do
      token = 'duplicate-token-123'

      create(:api_token, user: user, token: token)

      another_token = build(:api_token, user: user, token: token)

      expect(another_token).not_to be_valid
      expect(another_token.errors[:token]).to include('has already been taken')
    end
  end

  describe 'callbacks' do
    let(:user) { create(:user) }

    it 'generates a token before validation on create' do
      api_token = ApiToken.create(user: user)
      expect(api_token.token).to be_present
      expect(api_token.token.length).to eq(64)
    end

    it 'sets last_used_at before create' do
      api_token = ApiToken.create(user: user)
      expect(api_token.last_used_at).to be_within(1.second).of(Time.current)
    end
  end
end