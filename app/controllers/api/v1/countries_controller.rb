# frozen_string_literal: true

module Api
  module V1
    class CountriesController < ApiController
      def index
        countries = CS.countries.to_a.map { |country| { code: country.first.to_s, name: country.last } }

        render_response(data: countries)
      end
    end
  end
end
