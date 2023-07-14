# frozen_string_literal: true

module Request
  module JsonHelpers
    def json_response
      @json_response ||= parse_json(response)
    end

    private

    def parse_json(response = nil)
      raise 'No response' if response.blank?

      if response.body.blank?
        {}
      else
        parsed = JSON.parse(response.body)

        if parsed.is_a?(Hash)
          parsed.with_indifferent_access
        else
          parsed
        end
      end
    end
  end
end
