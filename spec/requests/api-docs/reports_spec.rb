# frozen_string_literal: true

require 'swagger_helper'

describe 'Reports API' do
  path '/api/v1/reports' do
    get 'Retrieve list of reports' do
      tags 'Reports'
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
                       id: { type: :string },
                       name: { type: :string },
                       quicksight_embed_src: { type: :string },
                       quicksight_dashboard_id: { type: :string },
                       organization: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string },
                           country: {
                             type: :object,
                             properties: {
                               code: { type: :string },
                               name: { type: :string }
                             }
                           },
                           report_id: { type: :string },
                           logo: { type: :string }
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

    post 'Create a new reports' do
      tags 'Reports'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :report, in: :body, schema: {
        type: :object,
        properties: {
          report: {
            type: :object,
            properties: {
              name: { type: :string },
              quicksight_embed_src: { type: :string },
              quicksight_dashboard_id: { type: :string },
              organization_id: { type: :string }
            },
            required: %w[name quicksight_embed_src quicksight_dashboard_id organization_id]
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
                     id: { type: :string },
                     name: { type: :string },
                     quicksight_embed_src: { type: :string },
                     quicksight_dashboard_id: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string },
                         country: {
                           type: :object,
                           properties: {
                             code: { type: :string },
                             name: { type: :string }
                           }
                         },
                         report_id: { type: :string },
                         logo: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/reports/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Report ID'

    get 'Retrieve a report by ID' do
      tags 'Reports'
      security [bearerAuth: []]

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     name: { type: :string },
                     quicksight_embed_src: { type: :string },
                     quicksight_dashboard_id: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string },
                         country: {
                           type: :object,
                           properties: {
                             code: { type: :string },
                             name: { type: :string }
                           }
                         },
                         report_id: { type: :string },
                         logo: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update a report by ID' do
      tags 'Reports'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :report, in: :body, schema: {
        type: :object,
        properties: {
          report: {
            type: :object,
            properties: {
              report: {
                type: :object,
                properties: {
                  name: { type: :string },
                  quicksight_embed_src: { type: :string },
                  quicksight_dashboard_id: { type: :string },
                  organization_id: { type: :string }
                }
              }
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
                     id: { type: :string },
                     name: { type: :string },
                     quicksight_embed_src: { type: :string },
                     quicksight_dashboard_id: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string },
                         country: {
                           type: :object,
                           properties: {
                             code: { type: :string },
                             name: { type: :string }
                           }
                         },
                         report_id: { type: :string },
                         logo: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    delete 'Delete report' do
      tags 'Reports'
      security [bearerAuth: []]

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 message: { type: :string }
               }

        xit
      end
    end
  end
end
