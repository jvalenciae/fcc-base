# frozen_string_literal: true

module Users
  class MemberSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :phone_number, :role, :groups_in_charge, :students_in_change

    def groups_in_charge
      0
    end

    def students_in_change
      0
    end
  end
end
