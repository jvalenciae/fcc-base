# frozen_string_literal: true

require 'swagger_helper'

describe 'Departments API' do
  path '/api/v1/departments' do
    get 'Retrieve list of departments' do
      tags 'Departments'
      security [bearerAuth: []]

      parameter name: 'countries[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of country codes to filter departments by', required: true

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       code: { type: :string },
                       name: { type: :string }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end
end
