# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :country, :role, :last_sign_in_at

  def last_sign_in_at
    object.last_sign_in_at&.strftime('%Y-%m-%d: %H:%M %Z')
  end
end
