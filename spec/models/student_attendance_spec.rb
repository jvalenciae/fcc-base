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

  describe 'delegations' do
    it 'validates delegations' do
      expect(student_attendance).to delegate_method(:date).to(:group_attendance)
    end
  end
end
