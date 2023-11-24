# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Students' do
  let(:super_admin) { create(:user, :super_admin) }
  let(:admin) { create(:user, :admin, organization: organization) }
  let(:organization) { create(:organization) }
  let(:member) { create(:user, branches: [member_branch], organization: organization) }
  let(:member_branch) { create(:branch, organization: organization) }

  before do
    create_list(:student, 5)
  end

  describe 'GET #index' do
    context 'when user is super_admin' do
      it 'returns a list of students' do
        get '/api/v1/students', headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(Student.count)
      end
    end

    context 'when user is an admin' do
      before do
        branch = create(:branch, organization: organization)
        group = create(:group, branch: branch)
        branch2 = create(:branch, organization: organization)
        group2 = create(:group, branch: branch2)
        create_list(:student, 3, group: group, branch: branch)
        create_list(:student, 3, group: group2, branch: branch2)
      end

      it 'returns students that are in the same organizations' do
        get '/api/v1/students', headers: authenticated_header(admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(6)
      end
    end

    context 'when user is a member' do
      before do
        group = create(:group, branch: member_branch)
        branch2 = create(:branch)
        group2 = create(:group, branch: branch2)
        create_list(:student, 3, group: group, branch: member_branch)
        create_list(:student, 3, group: group2, branch: branch2)
      end

      it 'returns students that are in the same branches' do
        get '/api/v1/students', headers: authenticated_header(member)
        expect(response).to have_http_status(:success)
        expect(json_response[:data].length).to eq(3)
      end
    end
  end

  describe 'GET #show' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:student) { create(:student) }
    let!(:id) { student.id }

    context 'when user have permissions' do
      it 'returns the details of a student' do
        get "/api/v1/students/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:id]).to eq(student.id)
        expect(json_response[:data][:name]).to eq(student.name)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        get "/api/v1/students/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    let(:student_params) do
      {
        student: student_attributes.merge({ supervisors_attributes: [supervisor_attributes] })
      }
    end
    let(:student_attributes) { attributes_for(:student, branch_id: branch.id, group_id: group.id) }
    let(:supervisor_attributes) { attributes_for(:supervisor) }
    let(:organization) { create(:organization) }
    let!(:branch) { create(:branch, organization: organization) }
    let!(:group) { create(:group, branch: branch) }

    let!(:super_admin) { create(:user, :super_admin) }

    context 'when the request is valid' do
      it 'creates a new student' do
        expect do
          post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        end.to change(Student, :count).by(1)
      end

      it 'returns a success response' do
        post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created student data' do
        post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        expect(json_response[:data]).to include(
          'id_number' => student_attributes[:id_number],
          'name' => student_attributes[:name],
          'gender' => student_attributes[:gender],
          'status' => student_attributes[:status]
        )
      end
    end

    context 'when the request is unauthorized' do
      let!(:unauthorized_user) { create(:user) }

      it 'does not create a new student' do
        expect do
          post '/api/v1/students', params: student_params, headers: authenticated_header(unauthorized_user)
        end.not_to change(Student, :count)
      end

      it 'returns an unauthorized response' do
        post '/api/v1/students', params: student_params, headers: authenticated_header(unauthorized_user)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the request is invalid' do
      before { student_params[:student][:name] = '' }

      it 'does not create a new student' do
        expect do
          post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        end.not_to change(Student, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post '/api/v1/students', params: student_params, headers: authenticated_header(super_admin)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let(:student_params) do
      {
        student: {
          name: 'LASTNAME FIRSTNAME'
        }
      }
    end

    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }

    before do
      create(:student, id: id)
    end

    context 'when user have permissions' do
      it 'updates the student' do
        put "/api/v1/students/#{id}", params: student_params, headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:data][:name]).to eq(student_params[:student][:name])
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        put "/api/v1/students/#{id}", params: student_params, headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }
    let!(:student) { create(:student, id: id) }

    context 'when user have permissions' do
      it 'soft deletes the student' do
        delete "/api/v1/students/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('Student successfully deleted')
        expect { Student.find(1234) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Student.with_deleted.find(id)).to eq(student)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/students/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #export' do
    let!(:super_admin) { create(:user, :super_admin) }

    before do
      create(:supervisor)
    end

    it 'exports students as CSV' do
      get '/api/v1/students/export.csv', headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Type']).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to eq('attachment; filename=students.csv')

      csv_data = response.body
      expected_csv = StudentsExportService.call(Student.all)
      expect(csv_data).to eq(expected_csv)
    end
  end

  describe 'POST #import' do
    let!(:super_admin) { create(:user, :super_admin) }
    let(:redis) { Redis.new }

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(ActiveStorage::Attached::One).to receive(:attach).and_return(true)
      # rubocop:enable RSpec/AnyInstance
    end

    it 'returns an error response if no file is provided' do
      post '/api/v1/students/import', headers: authenticated_header(super_admin)
      expect(response).to have_http_status(:bad_request)
      expect(json_response['message']).to eq(I18n.t('student.import.missing_file'))
    end

    it 'returns a success response when a file is provided' do
      FakeRedis.enable
      file = fixture_file_upload('children.csv', 'text/csv')
      post '/api/v1/students/import', params: { file: file }, headers: authenticated_header(super_admin)

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq(I18n.t('student.import.started'))
      FakeRedis.disable
    end
  end
end
