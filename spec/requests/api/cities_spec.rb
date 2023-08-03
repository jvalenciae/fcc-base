# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cities' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user) }
      let(:country_code) { 'US' }

      context 'when country code is provided' do
        it 'returns a list of cities for the specified country' do
          allow(CS).to receive(:states).with(country_code.to_sym).and_return({ 'NY' => 'New York',
                                                                               'CA' => 'California' })
          allow(CS).to receive(:cities).with('NY', country_code.to_sym).and_return(['New York City'])
          allow(CS).to receive(:cities).with('CA', country_code.to_sym).and_return(['Los Angeles', 'San Francisco'])

          get '/api/v1/cities', params: { country_code: country_code }, headers: authenticated_header(user)

          expect(response).to have_http_status(:success)
          expect(json_response[:data]).to eq(['New York City', 'Los Angeles', 'San Francisco'])
        end
      end

      context 'when country code is not provided' do
        it 'returns an empty list' do
          get '/api/v1/cities', headers: authenticated_header(user)

          expect(response).to have_http_status(:success)
          expect(json_response[:data]).to eq([])
        end
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/cities'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
