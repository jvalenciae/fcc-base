# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Countries' do
  describe 'GET #index' do
    before do
      allow(CS).to receive(:countries).and_return({ 'US' => 'United States', 'CA' => 'Canada' })

      get '/api/v1/countries'
    end

    it 'returns a list of countries' do
      expect(response).to have_http_status(:success)
      expect(json_response[:data]).to eq(
        [
          { 'code' => 'US', 'name' => 'United States' },
          { 'code' => 'CA', 'name' => 'Canada' }
        ]
      )
    end
  end
end
