# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Departments' do
  describe 'GET #index' do
    let(:user) { create(:user) }

    context 'with valid country_code' do
      it 'returns a list of departments' do
        allow(CS).to receive(:states).and_return({ 'CA' => 'California', 'TX' => 'Texas' })

        get '/api/v1/departments', params: { countries: ['US'] }, headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq([
                                             { 'code' => 'CA', 'name' => 'California' },
                                             { 'code' => 'TX', 'name' => 'Texas' }
                                           ])
      end
    end

    context 'with invalid country_code' do
      it 'returns an empty list' do
        allow(CS).to receive(:states).and_return(nil)

        get '/api/v1/departments', params: { country_code: 'INVALID' }, headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq([])
      end
    end
  end
end
