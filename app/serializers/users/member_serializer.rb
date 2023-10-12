# frozen_string_literal: true

module Users
  class MemberSerializer < ActiveModel::Serializer
    include UserConcerns

    attributes :id, :first_name, :last_name, :phone_number, :role, :type, :branches_in_charge, :students_in_charge
  end
end
