# frozen_string_literal: true

class String
  def to_boolean
    s = strip_downcase
    case s
    when 't', 'true', 'y', 'yes'
      true
    when 'f', 'false', 'n', 'no'
      false
    else
      ActiveRecord::Type::Boolean.new.cast(s)
    end
  end

  delegate :downcase, to: :strip, prefix: true
end

class NilClass
  def to_boolean
    false
  end
end

class TrueClass
  def to_boolean
    true
  end

  def to_i
    1
  end
end

class FalseClass
  def to_boolean
    false
  end

  def to_i
    0
  end
end
