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
          role: 'user'
        }
      }
    end
    let!(:admin_user) { create(:user, :super_admin) }

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
          'country' => { 'code' => 'CO', 'name' => 'Colombia' },
          'role' => 'user'
        )
      end

      it 'sends an invitation email if the user is member' do
        post '/api/v1/users', params: user_params, headers: authenticated_header(admin_user)
        user = User.last
        expect(UserMailer).to have_received(:invitation).with(user, admin_user)
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user, role: 'user') }

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

  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }

    it 'returns a list of users' do
      get '/api/v1/users', headers: authenticated_header(super_admin)
      expect(response).to have_http_status(:success)
      expect(json_response[:data].length).to eq(User.count - 1) # Excluding current_user
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:super_admin_id) { super_admin.id }
    let!(:user) { create(:user) }
    let!(:user_id) { user.id }

    context 'when user have permissions' do
      it 'returns the details of a user' do
        get "/api/v1/users/#{user_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(user.id)
        expect(json_response[:data][:email]).to eq(user.email)
        expect(json_response[:data][:role]).to eq(user.role)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/users/#{super_admin_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:super_admin_id) { super_admin.id }
    let!(:user) { create(:user) }
    let!(:user_id) { user.id }
    let(:user_params) do
      {
        user: {
          first_name: 'New_Name'
        }
      }
    end

    context 'when user have permissions' do
      it 'updates the user' do
        put "/api/v1/users/#{user_id}", params: user_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:first_name]).to eq(user_params[:user][:first_name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/users/#{super_admin_id}", params: user_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:super_admin_id) { super_admin.id }
    let!(:user) { create(:user) }
    let!(:user_id) { user.id }

    context 'when user have permissions' do
      it 'deletes the user' do
        delete "/api/v1/users/#{user_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('User successfully deleted')
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/users/#{super_admin_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
