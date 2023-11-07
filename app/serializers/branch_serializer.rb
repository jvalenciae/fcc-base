# frozen_string_literal: true

class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :department, :city, :address, :phone_number

  belongs_to :organization
  has_many :allies

  def organization
    organization = object.organization
    {
      id: organization.id,
      name: organization.name,
      country: country(organization)
    }
  end

  def country(object = @object)
    {
      code: object.country,
      name: CS.countries[object.country.to_sym]
    }
  end

  def department
    {
      code: object.department,
      name: CS.states(object.country.to_sym)[object.department.to_sym]
    }
  end
end
