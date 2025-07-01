require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:admin)     { create(:user, role: :admin) }
  let(:employee)  { create(:user, role: :employee) }
  let(:hr)        { create(:user, role: :hr) }
  let(:manager)   { create(:user, role: :manager) }
  let(:target_user) { create(:user) }

  permissions :create? do
    it 'allows admin to create user' do
      expect(subject).to permit(admin, User)
    end

    it 'does not allow employee to create user' do
      expect(subject).not_to permit(employee, User)
    end

    it 'does not allow HR to create user' do
      expect(subject).not_to permit(hr, User)
    end
  end

  permissions :destroy?, :inactivate? do
    it 'allows admin to delete user' do
      expect(subject).to permit(admin, target_user)
    end

    it 'does not allow employee to delete user' do
      expect(subject).not_to permit(employee, target_user)
    end

    it 'does not allow manager to delete user' do
      expect(subject).not_to permit(manager, target_user)
    end
  end
end

