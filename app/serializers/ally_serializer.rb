# frozen_string_literal: true

class AllySerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :organization
end
