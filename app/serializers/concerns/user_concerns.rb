# frozen_string_literal: true

module UserConcerns
  def type
    if object.super_admin?
      'super_admin'
    else
      'user'
    end
  end
end
