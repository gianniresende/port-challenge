require 'rails_helper'
RSpec.describe Api::V1::UserFilter do
  describe '.call' do
    let!(:admin)     { create(:user, name: 'Ana', role: :admin) }
    let!(:employee1) { create(:user, name: 'Carlos', role: :employee) }
    let!(:employee2) { create(:user, name: 'Carla', role: :employee) }

    let(:params) { {} }

    subject(:result) { described_class.call(params) }

    context 'when no filters are applied' do
      it 'returns all users' do
        expect(result).to contain_exactly(admin, employee1, employee2)
      end
    end

    context 'when filtering by name (partial match)' do
      let(:params) { { name: 'Car' } }

      it 'returns matching users' do
        expect(result).to contain_exactly(employee1, employee2)
      end
    end

    context 'when filtering by role' do
      let(:params) { { role: 'admin' } }

      it 'returns only admins' do
        expect(result).to eq([admin])
      end
    end

    context 'when filtering by status' do
      before { employee1.update!(status: :inactive) }
      let(:params) { { status: 'inactive' } }

      it 'returns only inactive users' do
        User.delete_all
        employee1 = create(:user, name: 'Carlos', role: :employee, status: :inactive)
        create(:user, name: 'Ana', role: :admin, status: :active)
        create(:user, name: 'João', role: :employee, status: :active)

        result = Api::V1::UserFilter.call({ status: 'inactive' })
        expect(result.map(&:id)).to eq([employee1.id])
      end
    end

    context 'when paginating results' do
      let(:params) { { page: 1, per_page: 2 } }

      it 'returns paginated users' do
        expect(result.size).to eq(2)
      end
    end
  end
end
