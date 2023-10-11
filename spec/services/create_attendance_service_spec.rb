# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAttendanceService do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:students) { create_list(:student, 5, group: group) }
  let(:params) do
    {
      date: Time.zone.today,
      group_id: group.id,
      attendances: students.map { |student| { student_id: student.id, present: true } }
    }
  end

  describe '#call' do
    it 'builds a group attendance record' do
      group_attendance, _student_attendances = described_class.call(params)

      expect(group_attendance).to be_a(GroupAttendance)
      expect(group_attendance.date).to eq(params[:date])
      expect(group_attendance.group).to eq(group)
    end

    it 'builds student attendance records' do
      _group_attendance, student_attendances = described_class.call(params)

      student_attendances.each do |student_attendance|
        expect(student_attendance).to be_present
        expect(student_attendance.present).to be(true)
      end
    end
  end
end
