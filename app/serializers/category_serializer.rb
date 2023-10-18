# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :label

  def id
    object
  end

  def label
    I18n.t("categories.#{object}")
  end
end
