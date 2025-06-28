require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  # it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end
  # it "is invalid without a role" do
  #   user = build(:user, role: nil)
  #   expect(user).to_not be_valid
  #   expect(user.errors[:role]).to include("can't be blank")
  # end

  # it "is invalid without an email" do
  #   user = User.new(password: "12345678", password_confirmation: "12345678")
  #   expect(user).to_not be_valid
  #   expect(user.errors[:email]).to include("can't be blank")
  # end

  describe '#admin?' do
    context 'quando o usuário é admin' do
      it 'retorna true' do
        user = build(:user, role: :admin)
        expect(user.admin?).to be true
      end
    end

    context 'quando o usuário não é admin' do
      it 'retorna false' do
        user = build(:user, role: :user)
        expect(user.admin?).to be false
      end
    end
  end
end
