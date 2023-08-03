# frozen_string_literal: true

require 'swagger_helper'

describe 'Cities API' do
  path '/api/v1/cities' do
    get 'Retrieve list of cities' do
      tags 'Cities'
      security [bearerAuth: []]

      produces 'application/json'
      parameter name: :country_code, in: :query, type: :string,
                description: 'Country code (ISO 3166-1 alpha-2) to filter cities by country'

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end
end
