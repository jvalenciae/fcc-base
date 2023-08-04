# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid credentials' do
      before do
        post '/api/v1/auth/sign_in', params: { user: { email: user.email, password: user.password } }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user data in the response' do
        user_data = json_response[:data][:user]
        expect(user_data[:email]).to eq(user.email)
        expect(user_data[:first_name]).to eq(user.first_name)
        expect(user_data[:last_name]).to eq(user.last_name)
        expect(user_data[:country]).to eq({ 'code' => 'CO', 'name' => 'Colombia' })
        expect(user_data[:role]).to eq(user.role)
      end
    end

    context 'with invalid credentials' do
      before do
        post '/api/v1/auth/sign_in', params: { user: { email: user.email, password: 'invalid_password' } }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message in the response' do
        expect(json_response[:error]).to eq('Invalid Email or password.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before do
        post '/api/v1/auth/sign_in', params: { user: { email: user.email, password: user.password } }
        token = response.headers['Authorization']
        delete '/api/v1/auth/sign_out', headers: { Authorization: token }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message in the response' do
        expect(json_response[:message]).to eq('Logged out successfully.')
      end
    end

    context 'when user is not logged in' do
      before do
        delete '/api/v1/auth/sign_out'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message in the response' do
        expect(json_response[:message]).to eq("Couldn't find an active session.")
      end
    end
  end
end
