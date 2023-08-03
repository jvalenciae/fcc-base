# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user) }
      let!(:first_organization) { create(:organization) }
      let!(:second_organization) { create(:organization) }

      before do
        get '/api/v1/organizations', headers: authenticated_header(user)
      end

      it 'returns a list of organizations' do
        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq(
          [
            { 'id' => first_organization.id, 'name' => first_organization.name,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'report_id' => first_organization.report_id },
            { 'id' => second_organization.id, 'name' => second_organization.name,
              'country' => { 'code' => 'CO', 'name' => 'Colombia' }, 'report_id' => second_organization.report_id }
          ]
        )
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/organizations'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
