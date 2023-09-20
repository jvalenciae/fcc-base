# frozen_string_literal: true

class GroupSerializer < ActiveModel::Serializer
  attributes :id, :category, :name

  belongs_to :branch
end
