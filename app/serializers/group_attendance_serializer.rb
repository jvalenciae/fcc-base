# frozen_string_literal: true

class GroupAttendanceSerializer < ActiveModel::Serializer
  attributes :id, :date

  belongs_to :group
  has_many :student_attendances
end
