# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups' do
  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :admin, organization: organization) }
    let!(:branch) { create(:branch, organization: organization) }
    let!(:trainer) { create(:user, organization: organization, branches: [branch]) }

    context 'when user is super_admin' do
      it 'returns a list of groups' do
        get '/api/v1/groups', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(Group.count)
      end
    end

    context 'when user is an admin' do
      before do
        branch = create(:branch, organization: organization)
        create_list(:group, 2, branch: branch)
      end

      it 'returns groups that are in the same organization' do
        get '/api/v1/groups', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(2)
      end
    end

    context 'when user is a member' do
      before do
        create(:group, branch: branch)
      end

      it 'only returns its group' do
        get '/api/v1/groups', headers: authenticated_header(trainer)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:group) { create(:group) }
    let!(:id) { group.id }

    context 'when user have permissions' do
      it 'returns the details of a group' do
        get "/api/v1/groups/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(group.id)
        expect(json_response[:data][:category]).to eq(group.category)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/groups/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:group_params) do
      {
        group: {
          category: 'creators',
          name: 'name',
          branch_id: branch.id
        }
      }
    end
    let(:organization) { create(:organization) }
    let(:branch) { create(:branch, organization: organization) }

    let!(:super_admin) { create(:user, :super_admin) }

    context 'when the request is valid' do
      it 'creates a new group' do
        expect do
          post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        end.to change(Group, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created group data' do
        post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        expect(json_response['data']).to include(
          'category' => 'creators'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user, role: 'trainer', organization: organization) }

      it 'does not create a new group' do
        expect do
          post '/api/v1/groups', params: group_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Group, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/groups', params: group_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { group_params[:group][:category] = '' }

      it 'does not create a new group' do
        expect do
          post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        end.not_to change(Group, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/groups', params: group_params, headers: authenticated_header(super_admin)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:group_params) do
      {
        group: {
          category: 'promoters'
        }
      }
    end

    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }

    before do
      create(:group, id: id)
    end

    context 'when user have permissions' do
      it 'updates the group' do
        put "/api/v1/groups/#{id}", params: group_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:category]).to eq(group_params[:group][:category])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/groups/#{id}", params: group_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }

    before do
      create(:group, id: id)
    end

    context 'when user have permissions' do
      it 'deletes the group' do
        delete "/api/v1/groups/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('Group successfully deleted.')
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/groups/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #categories' do
    let!(:super_admin) { create(:user, :super_admin) }

    it 'returns a list of group categories' do
      get '/api/v1/groups/categories', headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].count).to eq(Group::CATEGORIES.count)
    end
  end

  describe 'GET #export' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:group) { create(:group, category: 'creators') }

    it 'exports groups as CSV' do
      get '/api/v1/groups/export.csv', headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Type']).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to eq('attachment; filename=groups.csv')

      csv_data = response.body
      expected_csv = GroupsExportService.call([group])
      expect(csv_data).to eq(expected_csv)
    end
  end
end
