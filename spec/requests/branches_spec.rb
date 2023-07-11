require 'rails_helper'

RSpec.describe 'Branches', type: :request do
  describe 'GET #index' do
    let(:organization) { create(:organization) }

    let!(:branch1) { create(:branch, organization: organization) }
    let!(:branch2) { create(:branch, organization: organization) }

    it 'returns a list of branches for the specified organization' do
      get '/api/v1/branches', params: { organization_id: organization.id }

      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq(
        [
          { 'id' => branch1.id, 'name' => branch1.name, 'country' => branch1.country, 'city' => branch1.city,
            'address' => branch1.address, 'phone_number' => branch1.phone_number, 'organization_id' => branch1.organization_id },
          { 'id' => branch2.id, 'name' => branch2.name, 'country' => branch2.country, 'city' => branch2.city,
            'address' => branch2.address, 'phone_number' => branch2.phone_number, 'organization_id' => branch2.organization_id }
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
