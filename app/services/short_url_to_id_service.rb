# frozen_string_literal: true

class ShortUrlToIdService < TransformUrlBaseService
  def initialize(short_url)
    @short_url = short_url
  end

  def call
    id = 0
    @short_url.each_char do |char|
      id = (id * BASE) + ALPHABET.index(char)
    end
    id
  end
end
