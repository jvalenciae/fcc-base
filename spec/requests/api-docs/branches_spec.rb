# frozen_string_literal: true

require 'swagger_helper'

describe 'Branches API' do
  path '/api/v1/branches' do
    get 'Retrieve list of branches' do
      tags 'Branches'
      security [bearerAuth: []]

      parameter name: 'organization_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of organization IDs to filter branches by', required: false
      parameter name: :q, in: :query, type: :string,
                description: 'A query string to search for branches by name',
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
                       department: {
                         type: :object,
                         properties: {
                           code: { type: :string },
                           name: { type: :string }
                         }
                       },
                       city: { type: :string },
                       address: { type: :string },
                       phone_number: { type: :string },
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
                           }
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

    post 'Create a new branch' do
      tags 'Branches'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :branch, in: :body, schema: {
        type: :object,
        properties: {
          branch: {
            type: :object,
            properties: {
              name: { type: :string },
              country: { type: :string },
              city: { type: :string },
              address: { type: :string },
              phone_number: { type: :string },
              organization_id: { type: :integer },
              ally_ids: { type: :array, items: { type: :integer } }
            },
            required: %w[name country city address phone_number organization_id]
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
                     department: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
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
                         }
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

  path '/api/v1/branches/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Branch ID'

    get 'Retrieve a branch by ID' do
      tags 'Branches'
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
                     department: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
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
                         }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update a branch by ID' do
      tags 'Branches'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :branch, in: :body, schema: {
        type: :object,
        properties: {
          branch: {
            type: :object,
            properties: {
              name: { type: :string },
              country: { type: :string },
              city: { type: :string },
              address: { type: :string },
              phone_number: { type: :string },
              organization_id: { type: :integer },
              ally_ids: { type: :array, items: { type: :integer } }
            },
            required: %w[name country city address phone_number organization_id]
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
                     department: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
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
                         }
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
end
