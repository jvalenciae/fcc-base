# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'POST #create' do
    let(:user_params) do
      {
        user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'Password123!',
          phone_number: '123456789',
          country: 'CO',
          role: 'trainer',
          organization_ids: [organization.id],
          branch_ids: [branch.id]
        }
      }
    end
    let(:organization) { create(:organization) }
    let(:branch) { create(:branch, organizations: [organization]) }

    let!(:admin_user) { create(:user, :admin, organizations: [organization]) }

    context 'when the request is valid' do
      it 'creates a new user' do
        expect do
          post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        end.to change(User, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created user data' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        expect(json_response['data']).to include(
          'first_name' => 'John',
          'last_name' => 'Doe',
          'email' => 'john.doe@example.com',
          'country' => 'CO',
          'role' => 'trainer'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user, role: 'trainer', organizations: [organization]) }

      it 'does not create a new user' do
        expect do
          post '/api/v1/users', params: user_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(User, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { user_params[:user][:email] = '' }

      it 'does not create a new user' do
        expect do
          post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        end.not_to change(User, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end
end
