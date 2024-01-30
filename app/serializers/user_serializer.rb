# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include UserConcerns

  attributes :id, :email, :first_name, :last_name, :country, :role, :type, :last_sign_in_at

  def country(object = @object)
    {
      code: object.country,
      name: CS.countries[object.country.to_sym]
    }
  end

  def last_sign_in_at
    object.last_sign_in_at&.strftime('%Y-%m-%d: %H:%M %Z')
  end
end
