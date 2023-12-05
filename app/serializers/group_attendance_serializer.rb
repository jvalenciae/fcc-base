# frozen_string_literal: true

class GroupAttendanceSerializer < ActiveModel::Serializer
  attributes :id, :date

  belongs_to :group
  has_many :student_attendances

  class GroupSerializer < ActiveModel::Serializer
    attributes :id, :category, :name, :branch, :organization

    def organization
      organization = object.branch.organization
      {
        id: organization.id,
        name: organization.name
      }
    end

    def branch
      branch = object.branch
      {
        id: branch.id,
        name: branch.name
      }
    end
  end
end
