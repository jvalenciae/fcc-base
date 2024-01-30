# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  describe 'POST #create' do
    let(:task_params) do
      {
        task: {
          title: 'Title',
          description: 'Description',
          due_date: '01-01-2025',
          status: 'pending',
          user_id: user.id
        }
      }
    end
    let!(:admin_user) { create(:user, :super_admin) }
    let(:user) { create(:user) }

    context 'when the request is valid' do
      it 'creates a new task' do
        expect do
          post '/api/v1/tasks', params: task_params, headers: authenticated_header(admin_user)
        end.to change(Task, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/tasks', params: task_params, headers: authenticated_header(admin_user)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created task data' do
        post '/api/v1/tasks', params: task_params, headers: authenticated_header(admin_user)
        expect(json_response['data']).to include(
          'title' => 'Title',
          'description' => 'Description',
          'due_date' => '2025-01-01',
          'status' => 'pending'
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user, role: 'user') }

      it 'does not create a new user' do
        expect do
          post '/api/v1/tasks', params: task_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Task, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/tasks', params: task_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    let!(:super_admin) { create(:user, :super_admin) }

    it 'returns a list of tasks' do
      get '/api/v1/tasks', headers: authenticated_header(super_admin)
      expect(response).to have_http_status(:success)
      expect(json_response[:data].length).to eq(Task.count)
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    let!(:task_id) { task.id }

    context 'when user have permissions' do
      it 'returns the details of a task' do
        get "/api/v1/tasks/#{task_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(task.id)
        expect(json_response[:data][:title]).to eq(task.title)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/tasks/#{task_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    let!(:task_id) { task.id }
    let(:task_params) do
      {
        task: {
          title: 'New_Title'
        }
      }
    end

    context 'when user have permissions' do
      it 'updates the user' do
        put "/api/v1/tasks/#{task_id}", params: task_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:title]).to eq(task_params[:task][:title])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/tasks/#{task_id}", params: task_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    let!(:task_id) { task.id }

    context 'when user have permissions' do
      it 'deletes the task' do
        delete "/api/v1/tasks/#{task_id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/tasks/#{task_id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
