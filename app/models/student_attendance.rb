# frozen_string_literal: true

class StudentAttendance < ApplicationRecord
  self.implicit_order_column = 'created_at'

  acts_as_paranoid

  validates :present, inclusion: { in: [true, false] }

  belongs_to :group_attendance
  belongs_to :student

  delegate :date, to: :group_attendance
end
