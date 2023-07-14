# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations' do
  describe 'GET #index' do
    let!(:first_organization) { create(:organization) }
    let!(:second_organization) { create(:organization) }

    before do
      get '/api/v1/organizations'
    end

    it 'returns a list of organizations' do
      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq(
        [
          { 'id' => first_organization.id, 'name' => first_organization.name,
            'country' => first_organization.country, 'report_id' => first_organization.report_id },
          { 'id' => second_organization.id, 'name' => second_organization.name,
            'country' => second_organization.country, 'report_id' => second_organization.report_id }
        ]
      )
    end
  end
end
