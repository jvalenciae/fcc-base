# frozen_string_literal: true

require 'swagger_helper'

describe 'Branches API' do
  path '/api/v1/branches' do
    get 'Retrieve list of branches' do
      tags 'Branches'
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
                       id: { type: :integer },
                       name: { type: :string },
                       country: {
                         type: :object,
                         properties: {
                           code: { type: :string },
                           name: { type: :string }
                         }
                       },
                       city: { type: :string },
                       address: { type: :string },
                       phone_number: { type: :string },
                       organizations: {
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
                             }
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
              organization_ids: { type: :array, items: { type: :integer } }
            },
            required: %w[name country city address phone_number]
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
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
                     organizations: {
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
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
                     organizations: {
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
              organization_ids: { type: :array, items: { type: :integer } }
            },
            required: %w[name country city address phone_number]
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
                     city: { type: :string },
                     address: { type: :string },
                     phone_number: { type: :string },
                     organizations: {
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
