# frozen_string_literal: true

class StudentAttendanceSerializer < ActiveModel::Serializer
  attributes :id, :date, :present, :student

  def student
    {
      id: object.student.id,
      id_number: object.student.id_number,
      name: object.student.name
    }
  end
end
