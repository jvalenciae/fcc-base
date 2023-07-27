# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Countries' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user) }

      before do
        allow(CS).to receive(:countries).and_return({ 'US' => 'United States', 'CA' => 'Canada' })

        get '/api/v1/countries', headers: authenticated_header(user)
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

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/countries'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
