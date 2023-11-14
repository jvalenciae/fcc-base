# frozen_string_literal: true

module Api
  module V1
    class CitiesController < ApiController
      def index
        countries = params[:countries].present? ? params[:countries].map(&:to_sym) : []

        cities = []
        countries.each do |country_code|
          cities << CS.states(country_code).keys.flat_map { |state| CS.cities(state, country_code) }
        end

        render_response(data: cities.flatten)
      end
    end
  end
end
