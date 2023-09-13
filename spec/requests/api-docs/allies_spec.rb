# frozen_string_literal: true

require 'swagger_helper'

describe 'Allies API' do
  path '/api/v1/allies' do
    get 'Retrieve list of allies' do
      tags 'Allies'
      security [bearerAuth: []]

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
                       organization: {
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

    post 'Create a new ally' do
      tags 'Allies'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :ally, in: :body, schema: {
        type: :object,
        properties: {
          ally: {
            type: :object,
            properties: {
              name: { type: :string },
              organization_id: { type: :integer }
            },
            required: %w[name organization_id]
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 organization: {
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
               }

        xit
      end
    end
  end

  path '/api/v1/allies/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Ally ID'

    get 'Retrieve an ally by ID' do
      tags 'Allies'
      security [bearerAuth: []]

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 organization: {
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
               }

        xit
      end
    end

    put 'Update an ally by ID' do
      tags 'Allies'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :ally, in: :body, schema: {
        type: :object,
        properties: {
          ally: {
            type: :object,
            properties: {
              name: { type: :string },
              organization_id: { type: :integer }
            }
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 organization: {
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
               }

        xit
      end
    end
  end
end
