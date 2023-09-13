# frozen_string_literal: true

module Users
  class UserSerializer < ActiveModel::Serializer
    include UserConcerns

    attributes :id, :email, :first_name, :last_name, :country, :role, :type, :last_sign_in_at

    belongs_to :organization
    has_many :branches

    def organization
      organization = object.organization
      {
        id: organization.id,
        name: organization.name,
        country: country(organization),
        report_id: organization.report_id,
        logo: organization.logo.url,
        branches: organization_branches(organization)
      }
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
          organization_id: branch.organization_id
        }
      end
    end

    def department(branch)
      {
        code: branch.department,
        name: CS.states(branch.country.to_sym)[branch.department.to_sym]
      }
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
