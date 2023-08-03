# frozen_string_literal: true

require 'swagger_helper'

describe 'Countries API' do
  path '/api/v1/countries' do
    get 'Retrieve list of countries' do
      tags 'Countries'
      security [bearerAuth: []]

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
