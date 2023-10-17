# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentAttendance do
  subject(:student_attendance) { create(:student_attendance) }

  describe 'validations' do
    it 'validates inclusion' do
      expect(student_attendance).to validate_inclusion_of(:present).in_array([true, false])
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(student_attendance).to belong_to(:group_attendance)
      expect(student_attendance).to belong_to(:student)
    end
  end

  describe 'callbacks' do
    describe 'before_save :assign_date' do
      let(:student_attendance) { build(:student_attendance, date: nil) }

      it 'assigns date from group_attendance if date is nil' do
        group_attendance = create(:group_attendance, date: '2023-01-01')
        group_attendance.student_attendances << student_attendance
        expect(student_attendance.date).to eq(group_attendance.date)
      end

      it 'does not change date if it is already set' do
        group_attendance = create(:group_attendance, date: '2023-01-01')
        student_attendance.date = '2023-01-02'
        group_attendance.student_attendances << student_attendance
        expect(student_attendance.date.to_s).to eq('2023-01-02')
      end
    end
  end
end
