# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :country, :role

  has_many :organizations

  def organizations
    object.organizations.map do |organization|
      {
        id: organization.id,
        name: organization.name,
        country: organization.country,
        report_id: organization.report_id,
        branches: branches(organization)
      }
    end
  end

  def branches(organization)
    organization.branches.select { |branch| branch.user_ids.include?(object.id) }.map do |branch|
      {
        id: branch.id,
        name: branch.name,
        country: branch.country,
        city: branch.city,
        address: branch.address,
        phone_number: branch.phone_number
      }
    end
  end
end
