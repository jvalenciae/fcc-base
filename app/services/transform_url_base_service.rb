# frozen_string_literal: true

class TransformUrlBaseService < ApplicationService
  ALPHABET = ('a'..'z').to_a.join + ('A'..'Z').to_a.join + ('0'..'9').to_a.join
  BASE = ALPHABET.length
end
