# frozen_string_literal: true

module Api
  module V1
    class DepartmentsController < ApiController
      def index
        countries = params[:countries].present? ? params[:countries].map(&:to_sym) : []

        departments = []
        countries.each do |country_code|
          departments << CS.states(country_code).to_a.map do |department|
            { code: department.first.to_s, name: department.last }
          end
        end

        render_response(data: departments.flatten)
      end
    end
  end
end
