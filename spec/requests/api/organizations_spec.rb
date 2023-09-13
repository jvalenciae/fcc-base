# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations' do
  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }
    let(:organization2) { create(:organization) }
    let!(:admin) { create(:user, :admin, organization: organization) }
    let!(:trainer) { create(:user, organization: organization) }

    before do
      create_list(:organization, 5)
    end

    context 'when user is super_admin' do
      it 'returns a list of organizations' do
        get '/api/v1/organizations', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(Organization.count)
      end
    end

    context 'when user is an admin' do
      it 'returns organizations that the admin has access to' do
        get '/api/v1/organizations', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(1)
      end
    end

    context 'when user is a member' do
      it 'returns organizations that the member has access to' do
        get '/api/v1/organizations', headers: authenticated_header(trainer)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(1)
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/organizations'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:organization) { create(:organization, id: 123) }

    context 'when user have permissions' do
      it 'returns the details of an organization' do
        get '/api/v1/organizations/123', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(organization.id)
        expect(json_response[:data][:name]).to eq(organization.name)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get '/api/v1/organizations/123', headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:organization_params) do
      {
        organization: {
          name: 'Org',
          country: 'CO',
          report_id: '123456'
        }
      }
    end

    let!(:super_admin_user) { create(:user, :super_admin) }

    context 'when the request is valid' do
      it 'creates a new organization' do
        expect do
          post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        end.to change(Organization, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created organization data' do
        post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        expect(json_response['data']).to include(
          'name' => 'Org',
          'country' => { 'code' => 'CO', 'name' => 'Colombia' },
          'report_id' => '123456'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new organization' do
        expect do
          post '/api/v1/organizations', params: organization_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Organization, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/organizations', params: organization_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { organization_params[:organization][:name] = '' }

      it 'does not create a new organization' do
        expect do
          post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        end.not_to change(Organization, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/organizations', params: organization_params, headers: authenticated_header(super_admin_user)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:organization_params) do
      {
        organization: {
          name: 'New_Name'
        }
      }
    end

    before do
      create(:organization, id: 123)
    end

    context 'when user have permissions' do
      it 'updates the organization' do
        put '/api/v1/organizations/123', params: organization_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(organization_params[:organization][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put '/api/v1/organizations/123', params: organization_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
