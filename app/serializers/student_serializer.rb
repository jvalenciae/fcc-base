# frozen_string_literal: true

class StudentSerializer < ActiveModel::Serializer
  attributes :id, :id_number, :name, :gender, :status

  belongs_to :branch
  belongs_to :group
end
