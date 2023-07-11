require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  describe 'GET #index' do
    let!(:organization1) { create(:organization) }
    let!(:organization2) { create(:organization) }

    before do
      get '/api/v1/organizations'
    end

    it 'returns a list of organizations' do
      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq(
        [
          { 'id' => organization1.id, 'name' => organization1.name, 'country' => organization1.country, 'report_id' => organization1.report_id },
          { 'id' => organization2.id, 'name' => organization2.name, 'country' => organization2.country, 'report_id' => organization2.report_id }
        ]
      )
    end
  end
end
