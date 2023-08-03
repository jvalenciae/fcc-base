# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Branches' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user) }
      let(:organization) { create(:organization) }

      let!(:first_branch) { create(:branch, organizations: [organization]) }
      let!(:second_branch) { create(:branch, organizations: [organization]) }

      it 'returns a list of branches for the specified organization' do
        get '/api/v1/branches', params: { organization_id: organization.id }, headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq(
          [
            { 'id' => first_branch.id, 'name' => first_branch.name, 'city' => first_branch.city,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'address' => first_branch.address,
              'phone_number' => first_branch.phone_number,
              'organizations' => [{ 'id' => organization.id, 'name' => organization.name,
                                    'country' => organization.country }] },
            { 'id' => second_branch.id, 'name' => second_branch.name, 'city' => second_branch.city,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'address' => second_branch.address,
              'phone_number' => second_branch.phone_number,
              'organizations' => [{ 'id' => organization.id, 'name' => organization.name,
                                    'country' => organization.country }] }
          ]
        )
      end

      it 'returns empty if the organization does not exist' do
        get '/api/v1/branches', params: { organization_id: 9999 }, headers: authenticated_header(user)

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
end
