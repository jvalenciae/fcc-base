class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :city, :address, :phone_number, :organization_id
end
