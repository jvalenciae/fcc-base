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
          'country' => { 'code' => 'CO', 'name' => 'Colombia' },
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

  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :admin, organizations: [organization]) }
    let!(:trainer) { create(:user) }

    context 'when user is super_admin' do
      it 'returns a list of users' do
        get '/api/v1/users', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(User.count)
      end
    end

    context 'when user is an admin' do
      before do
        create(:user, organizations: [organization])
      end

      it 'returns users that are in the same organizations' do
        get '/api/v1/users', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(2)
      end
    end

    context 'when user is a member' do
      it 'only returns itself' do
        get '/api/v1/users', headers: authenticated_header(trainer)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin, id: 9999) }
    let!(:user) { create(:user, id: 1234) }

    context 'when user have permissions' do
      it 'returns the details of a user' do
        get '/api/v1/users/1234', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(user.id)
        expect(json_response[:data][:email]).to eq(user.email)
        expect(json_response[:data][:role]).to eq(user.role)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get '/api/v1/users/9999', headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin, id: 9999) }
    let!(:user) { create(:user, id: 1234) }
    let(:user_params) do
      {
        user: {
          first_name: 'New_Name'
        }
      }
    end

    context 'when user have permissions' do
      it 'updates the user' do
        put '/api/v1/users/1234', params: user_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:first_name]).to eq(user_params[:user][:first_name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put '/api/v1/users/9999', params: user_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin, id: 9999) }
    let!(:user) { create(:user, id: 1234) }

    context 'when user have permissions' do
      it 'deletes the user' do
        delete '/api/v1/users/1234', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('User successfully deleted.')
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete '/api/v1/users/9999', headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #members' do
    let(:org) { create(:organization) }
    let(:first_branch) { create(:branch, organizations: [org]) }
    let(:second_branch) { create(:branch, organizations: [org]) }

    let(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user, branches: [first_branch], organizations: [org]) }

    before do
      create(:user, branches: [second_branch], organizations: [org])
    end

    it 'returns a successful response with members filtered by branch_ids and q' do
      get '/api/v1/users/members', params: { branch_ids: [first_branch.id], q: user.first_name },
                                   headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].size).to eq(1)
      expect(json_response[:data][0][:id]).to eq(user.id)
    end

    it 'returns all members if branch_ids and q are blank' do
      get '/api/v1/users/members', headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].size).to eq(2)
    end

    it 'returns an empty array if no members match the criteria' do
      get '/api/v1/users/members', params: { branch_ids: [9999], q: 'nonexistent' },
                                   headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(json_response[:data]).to be_empty
    end
  end

  describe 'GET #roles' do
    let(:super_admin) { create(:user, :super_admin) }

    it 'returns a list of user roles' do
      get '/api/v1/users/roles', headers: authenticated_header(super_admin)
      expect(response).to have_http_status(:ok)
      expected_response = {
        super_admin: User::SUPER_ADMIN_ROLES.keys,
        admin: User::ADMIN_ROLES.keys,
        member: User::MEMBER_ROLES.keys
      }.with_indifferent_access
      expect(json_response[:data]).to eq(expected_response)
    end
  end
end
