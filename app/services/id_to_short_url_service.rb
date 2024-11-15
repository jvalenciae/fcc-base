# frozen_string_literal: true

class IdToShortUrlService < TransformUrlBaseService
  def initialize(id)
    @id = id
  end

  def call
    return ALPHABET[0] if @id.zero?

    shortened_url = ''
    while @id.positive?
      remainder = @id % BASE
      shortened_url = ALPHABET[remainder] + shortened_url
      @id /= BASE
    end
    shortened_url
  end
end
