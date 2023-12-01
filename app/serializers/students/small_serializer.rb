# frozen_string_literal: true

module Students
  class SmallSerializer < ActiveModel::Serializer
    attributes :id, :id_number, :name, :gender, :status

    belongs_to :branch
    belongs_to :group
    has_many :supervisors
  end
end
