# frozen_string_literal: true

require 'swagger_helper'

describe 'Cities API' do
  path '/api/v1/cities' do
    get 'Retrieve list of cities' do
      tags 'Cities'
      security [bearerAuth: []]

      parameter name: 'countries[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of country codes to filter cities by', required: true

      produces 'application/json'
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
