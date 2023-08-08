# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords' do
  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'when the email exists' do
      it 'generates a reset password token for the user' do
        post '/api/v1/auth/passwords', params: { email: user.email }
        user.reload
        expect(user.reset_password_token).not_to be_nil
      end

      # it 'sends a password reset email' do
      #   expect do
      #     post '/api/v1/auth/passwords', params: { email: user.email }
      #   end.to change(ActionMailer::Base.deliveries, :count).by(1)
      # end

      it 'returns the reset password token' do
        post '/api/v1/auth/passwords', params: { email: user.email }
        user.reload
        expect(json_response['token']).to eq(user.reset_password_token)
      end
    end

    context 'when the email does not exist' do
      it 'returns error not_found' do
        post '/api/v1/auth/passwords', params: { email: 'invalid_email' }
        expect(json_response['status']).to eq('not_found')
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:token) { 'valid_token' }

    before do
      user.generate_reset_password_token
      user.save
    end

    context 'when the token is valid' do
      let(:params) do
        {
          token: user.reset_password_token,
          password: 'Password123!',
          password_confirmation: 'Password123!'
        }
      end

      it 'returns a success response' do
        put '/api/v1/auth/passwords/update', params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        put '/api/v1/auth/passwords/update', params: params
        expect(json_response['message']).to eq('Password changed successfully')
      end
    end

    context 'when the token is invalid' do
      let(:params) do
        {
          token: 'invalid_token',
          password: 'Password123!',
          password_confirmation: 'Password123!'
        }
      end

      it 'returns error not_found' do
        put '/api/v1/auth/passwords/update', params: params
        expect(json_response['status']).to eq('not_found')
      end
    end
  end
end
