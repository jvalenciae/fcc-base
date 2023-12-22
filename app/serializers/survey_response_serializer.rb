# frozen_string_literal: true

class SurveyResponseSerializer < ActiveModel::Serializer
  attributes :id, :response_id, :date, :kind_of_measurement, :branch, :group

  belongs_to :student
  belongs_to :survey

  def branch
    branch = object.branch || object.student.group.branch
    {
      id: branch.id,
      name: branch.name
    }
  end

  def group
    group = object.student.group
    {
      id: group.id,
      category: group.category,
      display_name: group.display_name
    }
  end

  class StudentSerializer < ActiveModel::Serializer
    attributes :id, :id_number, :name
  end
end
