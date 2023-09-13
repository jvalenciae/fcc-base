# frozen_string_literal: true

module UserConcerns
  def type
    if object.super_admin?
      'super_admin'
    elsif object.admin?
      'admin'
    else
      'member'
    end
  end
end
