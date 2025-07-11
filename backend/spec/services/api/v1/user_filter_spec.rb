require 'rails_helper'

RSpec.describe Api::V1::UserFilter do
  describe '.call' do
    let!(:admin)     { create(:user, name: 'Ana', role: :admin) }
    let!(:employee1) { create(:user, name: 'Carlos', role: :employee) }
    let!(:employee2) { create(:user, name: 'Carla', role: :employee) }

    subject(:result) { described_class.call(params: params) }

    context 'when no filters are applied' do
      let(:params) { {} }

      it 'returns all users' do
        expect(result.success).to be true
        user_names = result.user[:data].map { |u| u[:attributes][:name] }
        expect(user_names).to contain_exactly('Ana', 'Carlos', 'Carla')
      end
    end

    context 'when filtering by name (partial match)' do
      let(:params) { { name: 'Car' } }

      it 'returns matching users' do
        expect(result.success).to be true
        user_names = result.user[:data].map { |u| u[:attributes][:name] }
        expect(user_names).to contain_exactly('Carlos', 'Carla')
      end
    end

    context 'when filtering by role' do
      let(:params) { { role: 'admin' } }

      it 'returns only admins' do
        expect(result.success).to be true
        roles = result.user[:data].map { |u| u[:attributes][:role] }
        expect(roles).to all(eq('admin'))
      end
    end

    context 'when filtering by status' do
      let!(:inactive_user)   { create(:user, name: 'Carlos', role: :employee, status: :inactive) }
      let!(:active_admin)    { create(:user, name: 'Ana', role: :admin, status: :active) }
      let!(:active_employee) { create(:user, name: 'João', role: :employee, status: :active) }

      let(:params) { { status: 'inactive' } }

      it 'returns only inactive users' do
        expect(result.success).to be true
        statuses = result.user[:data].map { |u| u[:attributes][:status] }
        expect(statuses).to all(eq('inactive'))
      end
    end

    context 'when paginating results' do
      let(:params) { { page: 1, per_page: 2 } }

      it 'returns paginated users' do
        expect(result.success).to be true
        expect(result.user[:data].size).to eq(2)
        expect(result.user[:meta]).to include(:current_page, :total_pages, :total_entries, :per_page)
      end
    end

    context 'caching' do
      let(:params) { {} }

      it 'caches the results' do
        expect(Rails.cache).to receive(:fetch).and_call_original
        described_class.call(params: params)
      end
    end

    context 'when an error occurs during filtering' do
      let(:params) { { per_page: 'invalid' } }

      before do
        allow_any_instance_of(Api::V1::UserFilter).to receive(:scoped_users).and_raise(StandardError.new("unexpected error"))
      end

      it 'returns failure result with error message' do
        expect(result.success).to be false
        expect(result.errors).to include("unexpected error")
        expect(result.user).to be_nil
      end
    end
  end
end