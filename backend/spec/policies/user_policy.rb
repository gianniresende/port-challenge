require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:admin)     { create(:user, role: :admin) }
  let(:employee)  { create(:user, role: :employee) }
  let(:hr)        { create(:user, role: :hr) }
  let(:manager)   { create(:user, role: :manager) }
  let(:target_user) { create(:user) }

  permissions :create? do
    it 'permite admin criar usuário' do
      expect(subject).to permit(admin, User)
    end

    it 'não permite employee criar usuário' do
      expect(subject).not_to permit(employee, User)
    end

    it 'não permite hr criar usuário' do
      expect(subject).not_to permit(hr, User)
    end
  end

  permissions :destroy? do
    it 'permite admin deletar usuário' do
      expect(subject).to permit(admin, target_user)
    end

    it 'não permite employee deletar usuário' do
      expect(subject).not_to permit(employee, target_user)
    end

    it 'não permite manager deletar usuário' do
      expect(subject).not_to permit(manager, target_user)
    end
  end
end

