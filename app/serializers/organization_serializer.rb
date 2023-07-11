class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :report_id
end
