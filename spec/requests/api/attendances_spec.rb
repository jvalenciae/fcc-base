# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendances' do
  let(:user) { create(:user, :super_admin) }
  let(:group) { create(:group) }
  let(:students) { create_list(:student, 5, group: group) }
  let(:attendance_date) { Time.zone.today }
  let(:attendance_params) do
    {
      group_attendance: {
        date: attendance_date,
        group_id: group.id,
        attendances: students.map { |student| { student_id: student.id, present: true } }
      }
    }
  end

  describe 'GET #index' do
    it 'returns a list of attendances' do
      create_list(:group_attendance, 3)
      get '/api/v1/attendances', headers: authenticated_header(user)
      expect(response).to have_http_status(:success)
      expect(json_response[:data].count).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns an attendance' do
      create_list(:group_attendance, 3, date: '2023-09-27')
      id = GroupAttendance.first.id
      get "/api/v1/attendances/#{id}", headers: authenticated_header(user)
      expect(response).to have_http_status(:success)
      expect(json_response[:data][:date]).to eq('2023-09-27')
    end
  end

  describe 'POST #create' do
    it 'creates a new group attendance' do
      expect do
        post '/api/v1/attendances', params: attendance_params, headers: authenticated_header(user)
      end.to change(GroupAttendance, :count).by(1)

      expect(response).to have_http_status(:success)

      group_attendance = GroupAttendance.last
      expect(group_attendance.date).to eq(attendance_date)
      expect(group_attendance.group).to eq(group)
    end

    it 'creates student attendance records' do
      expect do
        post '/api/v1/attendances', params: attendance_params, headers: authenticated_header(user)
      end.to change(StudentAttendance, :count).by(students.count)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    let!(:group_attendance) { create(:group_attendance) }
    let(:id) { group_attendance.id }

    let(:update_params) do
      {
        group_attendance: {
          date: '2030-09-27',
          attendances: [
            { student_id: students.first.id, present: true },
            { student_id: students.last.id, present: false }
          ]
        }
      }
    end

    it 'updates the attendance' do
      put "/api/v1/attendances/#{id}", params: update_params, headers: authenticated_header(user)
      group_attendance.reload

      expect(response).to have_http_status(:success)
      expect(group_attendance.date.to_s).to eq('2030-09-27')
      expect(group_attendance.student_attendances.count).to eq(2)
      expect(group_attendance.student_attendances.first.present).to be_truthy
      expect(group_attendance.student_attendances.last.present).to be_falsy
    end
  end

  describe 'DELETE #destroy' do
    let!(:super_admin) { create(:user, :super_admin) }
    let!(:user) { create(:user) }
    let!(:id) { 'c15cc7ea-3203-47c0-bb59-a34dc5d22c0c' }
    let!(:group_attendance) { create(:group_attendance, id: id) }

    context 'when user have permissions' do
      it 'soft deletes the group_attendance' do
        delete "/api/v1/attendances/#{id}", headers: authenticated_header(super_admin)
        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq('Attendance successfully deleted')
        expect { GroupAttendance.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when user does not have permissions' do
      it 'gives unauthorized' do
        delete "/api/v1/attendances/#{id}", headers: authenticated_header(user)
        expect(response).to have_http_status(:unauthorized)
        expect(GroupAttendance.find(id)).to eq(group_attendance)
      end
    end
  end
end
