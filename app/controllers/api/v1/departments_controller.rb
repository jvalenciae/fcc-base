# frozen_string_literal: true

module Api
  module V1
    class DepartmentsController < ApiController
      def index
        country_code = params[:country_code]&.to_sym
        departments = CS.states(country_code).to_a.map do |department|
          { code: department.first.to_s, name: department.last }
        end

        render_response(data: departments)
      end
    end
  end
end
