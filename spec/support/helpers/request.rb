# frozen_string_literal: true

module Request
  module JsonHelpers
    def json_response
      @json_response ||= parse_json(response)
    end

    private

    def parse_json(response = nil)
      raise 'No response' if response.blank?

      return {} if response.body.blank?

      parsed = JSON.parse(response.body)
      return parsed.with_indifferent_access if parsed.is_a?(Hash)

      parsed
    end
  end
end
