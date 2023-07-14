# frozen_string_literal: true

class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :report_id
end
