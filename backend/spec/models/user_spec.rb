require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }

    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to define_enum_for(:role).with_values(%i[employee hr manager admin]) }
  end

  describe 'UUID as primary key' do
    it 'has a valid UUID as id' do
      user = create(:user)
      expect(user.id).to be_present
      expect(user.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role).with_values(%i[employee hr manager admin]) }
    it { is_expected.to define_enum_for(:status).with_values(%i[inactive active]) }
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
        user = build(:user, role: :employee)
        expect(user.admin?).to be false
      end
    end

    it 'when return only admins' do
      create(:user, role: :admin)
      create(:user, role: :employee)
      expect(User.admin.count).to eq(1)
    end
  end

  describe 'callbacks' do
    context 'on create' do
      it 'generates a random password if none is provided' do
        user = build(:user, password: nil, password_confirmation: nil)
        user.valid?
        expect(user.password).to be_present
        expect(user.password.length).to be >= 20
      end

      it 'sets uid as email if uid is blank' do
        user = build(:user, uid: nil, email: 'test@example.com')
        user.valid?
        expect(user.uid).to eq('test@example.com')
      end

      it 'does not overwrite uid if already set' do
        user = build(:user, uid: 'custom_uid', email: 'test@example.com')
        user.valid?
        expect(user.uid).to eq('custom_uid')
      end
    end
  end

  describe 'scopes' do
    let!(:employee) { create(:user, name: 'Carlos Silva', email: 'carlos@example.com', role: :employee, status: :active) }
    let!(:hr)       { create(:user, name: 'Helena Ramos', email: 'helena@example.com', role: :hr, status: :inactive) }

    describe '.by_name' do
      it 'returns users matching partial name' do
        expect(User.by_name('car')).to include(employee)
        expect(User.by_name('car')).not_to include(hr)
      end

      it 'returns all users if name is nil' do
        expect(User.by_name(nil)).to include(employee, hr)
      end
    end

    describe '.by_email' do
      it 'returns users matching partial email' do
        expect(User.by_email('helena')).to include(hr)
        expect(User.by_email('helena')).not_to include(employee)
      end
    end

    describe '.by_role' do
      it 'returns users by role' do
        expect(User.by_role(:hr)).to eq([hr])
      end
    end

    describe '.by_status' do
      it 'returns users by status' do
        expect(User.by_status(:active)).to eq([employee])
      end
    end

    describe '.ordered_by' do
      it 'orders users by name ascending' do
        expect(User.ordered_by(:name, :asc).first).to eq(employee)
      end

      it 'orders users by created_at descending' do
        expect(User.ordered_by(:created_at, :desc).first).to eq(hr)
      end

      it 'returns all if invalid field or direction' do
        expect(User.ordered_by(:unknown, :asc)).to include(employee, hr)
        expect(User.ordered_by(:name, :sideways)).to include(employee, hr)
      end
    end
  end
end
