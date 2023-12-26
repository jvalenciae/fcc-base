# frozen_string_literal: true

class SurveySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :form_id, :default

  belongs_to :organization

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
end
