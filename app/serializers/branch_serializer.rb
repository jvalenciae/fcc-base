# frozen_string_literal: true

class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :city, :address, :phone_number

  has_many :organizations

  def organizations
    object.organizations.map do |organization|
      {
        id: organization.id,
        name: organization.name,
        country: organization.country
      }
    end
  end
end
