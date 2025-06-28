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

  describe 'password validation' do
    it 'is invalid when password is shorter than 6 characters' do
      user = build(:user, password: '123', password_confirmation: '123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'UUID as primary key' do
    it 'has a valid UUID as id' do
      user = create(:user)
      expect(user.id).to be_present
      expect(user.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role).with_values(%i[user admin]) }
    it { is_expected.to define_enum_for(:status).with_values(%i[active inactive]) }
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
