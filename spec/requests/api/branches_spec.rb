# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Branches' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user, :super_admin) }
      let(:organization) { create(:organization) }

      let!(:first_branch) { create(:branch, organizations: [organization]) }
      let!(:second_branch) { create(:branch, organizations: [organization]) }

      it 'returns a list of branches for the specified organization' do
        get '/api/v1/branches', params: { organization_ids: [organization.id] }, headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq(
          [
            { 'id' => first_branch.id, 'name' => first_branch.name, 'city' => first_branch.city,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'address' => first_branch.address,
              'department' => { 'code' => 'ATL', 'name' => 'Atlántico' }, 'phone_number' => first_branch.phone_number,
              'organizations' => [{ 'id' => organization.id, 'name' => organization.name,
                                    'country' => { 'code' => 'CO', 'name' => 'Colombia' } }] },
            { 'id' => second_branch.id, 'name' => second_branch.name, 'city' => second_branch.city,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'address' => second_branch.address,
              'department' => { 'code' => 'ATL', 'name' => 'Atlántico' }, 'phone_number' => second_branch.phone_number,
              'organizations' => [{ 'id' => organization.id, 'name' => organization.name,
                                    'country' => { 'code' => 'CO', 'name' => 'Colombia' } }] }
          ]
        )
      end

      it 'returns empty if the organization does not exist' do
        get '/api/v1/branches', params: { organization_ids: [9999] }, headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq([])
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/branches'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:branch) { create(:branch, id: 123) }

    context 'when user have permissions' do
      it 'returns the details of a branch' do
        get '/api/v1/branches/123', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(branch.id)
        expect(json_response[:data][:name]).to eq(branch.name)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get '/api/v1/branches/123', headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:branch_params) do
      {
        branch: {
          name: 'Branch',
          country: 'CO',
          department: 'ATL',
          city: 'Barranquilla',
          address: 'Addr',
          phone_number: '1234567890'
        }
      }
    end

    let!(:super_admin_user) { create(:user, :super_admin) }

    context 'when the request is valid' do
      it 'creates a new branch' do
        expect do
          post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        end.to change(Branch, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created branch data' do
        post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        expect(json_response[:data]).to include(
          'name' => 'Branch',
          'country' => { 'code' => 'CO', 'name' => 'Colombia' },
          'department' => { 'code' => 'ATL', 'name' => 'Atlántico' },
          'city' => 'Barranquilla',
          'address' => 'Addr',
          'phone_number' => '1234567890'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new branch' do
        expect do
          post '/api/v1/branches', params: branch_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Branch, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/branches', params: branch_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { branch_params[:branch][:name] = '' }

      it 'does not create a new branch' do
        expect do
          post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        end.not_to change(Branch, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/branches', params: branch_params, headers: authenticated_header(super_admin_user)
        expect(json_response[:errors]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:branch_params) do
      {
        branch: {
          name: 'New_Name'
        }
      }
    end

    before do
      create(:branch, id: 123)
    end

    context 'when user have permissions' do
      it 'updates the branch' do
        put '/api/v1/branches/123', params: branch_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(branch_params[:branch][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put '/api/v1/branches/123', params: branch_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
