require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:record) { create(:user) }

  context 'when user is admin' do
    let(:admin_user) { create(:user, role: 'admin') }

    permissions :create?, :inactivate?, :destroy? do
      it 'grants access' do
        expect(subject).to permit(admin_user, record)
      end
    end
  end

  context 'when user is HR' do
    let(:hr_user) { create(:user, role: 'hr') }

    permissions :create?, :inactivate? do
      it 'grants access' do
        expect(subject).to permit(hr_user, record)
      end
    end

    permissions :destroy? do
      it 'denies access' do
        expect(subject).not_to permit(hr_user, record)
      end
    end
  end

  context 'when user is a regular collaborator' do
    let(:collaborator_user) { create(:user, role: 'colaborador') }

    permissions :create?, :inactivate?, :destroy? do
      it 'denies access' do
        expect(subject).not_to permit(collaborator_user, record)
      end
    end
  end
end