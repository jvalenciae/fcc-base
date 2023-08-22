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
          country: country(organization),
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
          country: country(branch),
          department: department(branch),
          city: branch.city,
          address: branch.address,
          phone_number: branch.phone_number,
          organizations: branch_organizations(branch)
        }
      end
    end

    def department(branch)
      {
        code: branch.department,
        name: CS.states(branch.country.to_sym)[branch.department.to_sym]
      }
    end

    def branch_organizations(branch)
      branch.organizations.select { |organization| organization.user_ids.include?(object.id) }.map(&:id)
    end

    def country(object = @object)
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
