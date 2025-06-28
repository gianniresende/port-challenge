require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'auth' do
    let(:user) { create(:user, password: '12345678', password_confirmation: '12345678') }

    it 'when correct password' do
      expect(user.valid_password?('12345678')).to be true
    end

    it 'when incorrect password' do
      expect(user.valid_password?('senhaerrada')).to be false
    end
  end

  describe 'validation of password' do
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe '#admin?' do
    context 'when user is admin' do
      it 'return true' do
        user = build(:user, role: :admin)
        expect(user.admin?).to be true
      end
    end

    context 'when user is not admin' do
      it 'return false' do
        user = build(:user, role: :user)
        expect(user.admin?).to be false
      end
    end

    it 'when return only admins' do
      create(:user, role: :admin)
      create(:user, role: :user)
      expect(User.admin.count).to eq(1)
    end
  end
end
