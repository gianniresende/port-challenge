require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_params) do
      {
        user: {
          email: 'john@example.com',
          name: 'John Doe',
          role: 'admin'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user, sends password email, and returns created status' do
        mailer_double = double('Mailer', deliver_later: true)
        allow(UserMailer).to receive(:send_password_email).and_return(mailer_double)

        expect {
          post '/api/v1/users', params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['id']).to be_present
        expect(json['message']).to eq('User created')

        expect(UserMailer).to have_received(:send_password_email).with(kind_of(User), kind_of(String))
        expect(mailer_double).to have_received(:deliver_later)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns errors' do
        post '/api/v1/users', params: { user: { email: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank")
      end
    end
  end
end
