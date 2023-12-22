# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SurveyResponses' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user, :super_admin) }
      let(:organization) { create(:organization) }
      let(:empty_user) { create(:user) }

      before do
        create_list(:survey_response, 5)
      end

      it 'returns a list of survey_responses' do
        get '/api/v1/survey_responses', headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data].size).to eq(SurveyResponse.count)
      end

      it 'returns empty if the user does not have access to any' do
        get '/api/v1/survey_responses', headers: authenticated_header(empty_user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq([])
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/survey_responses'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
