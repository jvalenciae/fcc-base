# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Surveys' do
  describe 'GET #index' do
    context 'when user logged in' do
      let(:user) { create(:user, :super_admin) }
      let(:organization) { create(:organization) }
      let(:empty_user) { create(:user) }

      before do
        create_list(:survey, 5, organization: organization)
      end

      it 'returns a list of surveys' do
        get '/api/v1/surveys', headers: authenticated_header(user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data].size).to eq(Survey.count)
      end

      it 'returns empty if the user does not have access to any' do
        get '/api/v1/surveys', headers: authenticated_header(empty_user)

        expect(response).to have_http_status(:success)
        expect(json_response[:data]).to eq([])
      end
    end

    context 'when user not logged in' do
      it 'returns an error' do
        get '/api/v1/surveys'

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:survey) { create(:survey) }
    let!(:id) { survey.id }

    context 'when user have permissions' do
      it 'returns the details of a survey' do
        get "/api/v1/surveys/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(survey.id)
        expect(json_response[:data][:name]).to eq(survey.name)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/surveys/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:survey_params) do
      {
        survey: {
          name: 'name',
          description: 'description',
          form_id: 'form_id',
          organization_id: organization.id
        }
      }
    end

    let!(:super_admin_user) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }

    context 'when the request is valid' do
      it 'creates a new survey' do
        expect do
          post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        end.to change(Survey, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created survey data' do
        post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        expect(json_response[:data]).to include(
          'name' => 'name',
          'description' => 'description',
          'form_id' => 'form_id'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new survey' do
        expect do
          post '/api/v1/surveys', params: survey_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Survey, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/surveys', params: survey_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { survey_params[:survey][:name] = '' }

      it 'does not create a new survey' do
        expect do
          post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        end.not_to change(Survey, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/surveys', params: survey_params, headers: authenticated_header(super_admin_user)
        expect(json_response[:errors]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:survey_params) do
      {
        survey: {
          name: 'New_Name'
        }
      }
    end
    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }

    before do
      create(:survey, id: id)
    end

    context 'when user have permissions' do
      it 'updates the survey' do
        put "/api/v1/surveys/#{id}", params: survey_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(survey_params[:survey][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/surveys/#{id}", params: survey_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
