# frozen_string_literal: true

class GroupSerializer < ActiveModel::Serializer
  attributes :id, :category, :name, :organization

  belongs_to :branch

  def organization
    organization = object.branch.organization
    {
      id: organization.id,
      name: organization.name
    }
  end
end
