# frozen_string_literal: true

require 'swagger_helper'

describe 'Organizations API' do
  path '/api/v1/organizations' do
    get 'Retrieve list of organizations' do
      tags 'Organizations'
      security [bearerAuth: []]

      parameter name: :q, in: :query, type: :string,
                description: 'A query string to search for organizations by name',
                required: false
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'How many records per page'

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
                       id: { type: :integer },
                       name: { type: :string },
                       country: {
                         type: :object,
                         properties: {
                           code: { type: :string },
                           name: { type: :string }
                         }
                       },
                       report_id: { type: :string }
                     }
                   }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     total_pages: { type: :integer },
                     page_number: { type: :integer },
                     max_per_page: { type: :integer },
                     total_resources: { type: :integer }
                   }
                 }
               }

        xit
      end
    end

    post 'Create a new organization' do
      tags 'Organizations'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :organization, in: :body, schema: {
        type: :object,
        properties: {
          organization: {
            type: :object,
            properties: {
              name: { type: :string },
              country: { type: :string },
              report_id: { type: :string }
            },
            required: %w[name country report_id]
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     report_id: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/organizations/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Organization ID'

    get 'Retrieve an organization by ID' do
      tags 'Organizations'
      security [bearerAuth: []]

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     report_id: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update an organization by ID' do
      tags 'Organizations'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :organization, in: :body, schema: {
        type: :object,
        properties: {
          organization: {
            type: :object,
            properties: {
              name: { type: :string },
              country: { type: :string },
              report_id: { type: :string }
            }
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     report_id: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end
end
