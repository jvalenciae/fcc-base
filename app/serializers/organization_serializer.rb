# frozen_string_literal: true

class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :report_id, :logo

  def country
    {
      code: object.country,
      name: CS.countries[object.country.to_sym]
    }
  end

  def logo
    object.logo.url(expires_in: 1.week)
  end
end
