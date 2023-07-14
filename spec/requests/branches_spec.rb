# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Branches' do
  describe 'GET #index' do
    let(:organization) { create(:organization) }

    let!(:first_branch) { create(:branch, organization: organization) }
    let!(:second_branch) { create(:branch, organization: organization) }

    it 'returns a list of branches for the specified organization' do
      get '/api/v1/branches', params: { organization_id: organization.id }

      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq(
        [
          { 'id' => first_branch.id, 'name' => first_branch.name, 'country' => first_branch.country,
            'city' => first_branch.city, 'address' => first_branch.address, 'phone_number' => first_branch.phone_number,
            'organization_id' => first_branch.organization_id },
          { 'id' => second_branch.id, 'name' => second_branch.name, 'country' => second_branch.country,
            'city' => second_branch.city, 'address' => second_branch.address,
            'phone_number' => second_branch.phone_number, 'organization_id' => second_branch.organization_id }
        ]
      )
    end

    it 'returns empty if the organization does not exist' do
      get '/api/v1/branches', params: { organization_id: 9999 }

      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq([])
    end
  end
end
