# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports' do
  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :admin, organization: organization) }
    let!(:trainer) { create(:user, organization: organization) }

    before do
      create_list(:report, 5, organization: organization)
      create_list(:report, 5)
    end

    context 'when user is super_admin' do
      it 'returns a list of reports' do
        get '/api/v1/reports', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(Report.count)
      end
    end

    context 'when user is an admin' do
      it 'returns reports that are in the same organization' do
        get '/api/v1/reports', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(5)
      end
    end

    context 'when user is a member' do
      it 'returns reports that are in the same organization' do
        get '/api/v1/reports', headers: authenticated_header(trainer)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(5)
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:report) { create(:report) }
    let!(:report_id) { report.id }
    let!(:user) { create(:user) }

    context 'when user have permissions' do
      it 'returns the details of a report' do
        get "/api/v1/reports/#{report_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(report.name)
        expect(json_response[:data][:quicksight_embed_src]).to eq(report.quicksight_embed_src)
        expect(json_response[:data][:quicksight_dashboard_id]).to eq(report.quicksight_dashboard_id)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/reports/#{report_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:report_params) do
      {
        report: {
          name: 'name',
          quicksight_embed_src: 'embed_src',
          quicksight_dashboard_id: 'dashboard_id',
          organization_id: organization.id
        }
      }
    end

    let!(:super_admin) { create(:user, :super_admin) }
    let!(:organization) { create(:organization) }

    context 'when the request is valid' do
      it 'creates a new report' do
        expect do
          post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        end.to change(Report, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created report data' do
        post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        expect(json_response['data']).to include(
          'name' => 'name',
          'quicksight_embed_src' => 'embed_src',
          'quicksight_dashboard_id' => 'dashboard_id'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new report' do
        expect do
          post '/api/v1/reports', params: report_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Report, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/reports', params: report_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { report_params[:report][:name] = '' }

      it 'does not create a new report' do
        expect do
          post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        end.not_to change(Report, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/reports', params: report_params, headers: authenticated_header(super_admin)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:report) { create(:report) }
    let!(:report_id) { report.id }
    let!(:user) { create(:user) }
    let(:report_params) do
      {
        report: {
          name: 'New_Name'
        }
      }
    end

    context 'when user have permissions' do
      it 'updates the report' do
        put "/api/v1/reports/#{report_id}", params: report_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(report_params[:report][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/reports/#{report_id}", params: report_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:report) { create(:report) }
    let!(:report_id) { report.id }
    let!(:user) { create(:user) }

    context 'when user have permissions' do
      it 'deletes the report' do
        delete "/api/v1/reports/#{report_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('Report successfully deleted')
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/reports/#{report_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
