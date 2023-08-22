# frozen_string_literal: true

require 'swagger_helper'

describe 'Departments API' do
  path '/api/v1/departments' do
    get 'Retrieve list of departments' do
      tags 'Departments'
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
