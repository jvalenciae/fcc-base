# frozen_string_literal: true

class SupervisorSerializer < ActiveModel::Serializer
  attributes :id, :id_number, :name, :email, :birthdate, :phone_number, :profession, :relationship
end
