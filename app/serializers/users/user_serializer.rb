# frozen_string_literal: true

module Users
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :first_name, :last_name, :country, :role, :last_sign_in_at

    has_many :organizations
    has_many :branches

    def organizations
      object.organizations.map do |organization|
        {
          id: organization.id,
          name: organization.name,
          country: organization.country,
          report_id: organization.report_id,
          logo: organization.logo.url,
          branches: organization_branches(organization)
        }
      end
    end

    def organization_branches(organization)
      organization.branches.select { |branch| branch.user_ids.include?(object.id) }.map(&:id)
    end

    def branches
      object.branches.map do |branch|
        {
          id: branch.id,
          name: branch.name,
          country: branch.country,
          city: branch.city,
          address: branch.address,
          phone_number: branch.phone_number,
          organizations: branch_organizations(branch)
        }
      end
    end

    def branch_organizations(branch)
      branch.organizations.select { |organization| organization.user_ids.include?(object.id) }.map(&:id)
    end

    def country
      {
        code: object.country,
        name: CS.countries[object.country.to_sym]
      }
    end

    def last_sign_in_at
      object.last_sign_in_at&.strftime('%Y-%m-%d: %H:%M %Z')
    end
  end
end
