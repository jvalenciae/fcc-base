# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Allies' do
  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :admin, organization: organization) }
    let!(:trainer) { create(:user, organization: organization) }

    before do
      create_list(:ally, 5)
    end

    context 'when user is super_admin' do
      it 'returns a list of allies' do
        get '/api/v1/allies', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(Ally.count)
      end
    end

    context 'when user is an admin' do
      before do
        create_list(:ally, 3, organization: organization)
      end

      it 'returns allies that the admin has access to' do
        get '/api/v1/allies', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(3)
      end
    end

    context 'when user is a member' do
      before do
        create_list(:ally, 3, organization: organization)
      end

      it 'returns allies that the member has access to' do
        get '/api/v1/allies', headers: authenticated_header(trainer)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(3)
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/allies'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:ally) { create(:ally, id: 123) }

    context 'when user have permissions' do
      it 'returns the details of an ally' do
        get '/api/v1/allies/123', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(ally.id)
        expect(json_response[:data][:name]).to eq(ally.name)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get '/api/v1/allies/123', headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:ally_params) do
      {
        ally: {
          name: 'Ally',
          organization_id: organization.id
        }
      }
    end

    let!(:super_admin_user) { create(:user, :super_admin) }
    let!(:organization) { create(:organization) }

    context 'when the request is valid' do
      it 'creates a new ally' do
        expect do
          post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        end.to change(Ally, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created ally data' do
        post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        expect(json_response['data']).to include(
          'name' => 'Ally'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new ally' do
        expect do
          post '/api/v1/allies', params: ally_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Ally, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/allies', params: ally_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { ally_params[:ally][:name] = '' }

      it 'does not create a new ally' do
        expect do
          post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        end.not_to change(Ally, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/allies', params: ally_params, headers: authenticated_header(super_admin_user)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:ally_params) do
      {
        ally: {
          name: 'New_Name'
        }
      }
    end

    before do
      create(:ally, id: 123)
    end

    context 'when user have permissions' do
      it 'updates the ally' do
        put '/api/v1/allies/123', params: ally_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(ally_params[:ally][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put '/api/v1/allies/123', params: ally_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
