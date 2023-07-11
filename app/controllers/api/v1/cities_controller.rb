module Api
  module V1
    class CitiesController < ApiController
      def index
        country_code = city_params[:country_code]&.to_sym
        cities = CS.states(country_code).keys.flat_map { |state| CS.cities(state, country_code) }

        render_response(data: cities)
      end

      private

      def city_params
        params.permit(:country_code)
      end
    end
  end
end
