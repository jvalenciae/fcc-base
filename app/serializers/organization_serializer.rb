# frozen_string_literal: true

class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :report_id

  def country
    {
      code: object.country,
      name: CS.countries[object.country.to_sym]
    }
  end
end
