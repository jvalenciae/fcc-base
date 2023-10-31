# frozen_string_literal: true

require 'swagger_helper'

describe 'Groups API' do
  path '/api/v1/groups' do
    get 'Retrieve list of groups' do
      tags 'Groups'
      security [bearerAuth: []]

      parameter name: 'categories[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of categories to filter groups by', required: false
      parameter name: 'branch_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of branch IDs to filter groups by', required: false
      parameter name: :q, in: :query, type: :string,
                description: 'A query string to search groups by name, cateogry, or branch.name',
                required: false

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
                       category: { type: :string },
                       name: { type: :string },
                       organization: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string }
                         }
                       },
                       branch: {
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
                           city: { type: :string },
                           address: { type: :string },
                           phone_number: { type: :string }
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

    post 'Create a new group' do
      tags 'Groups'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: {
          group: {
            type: :object,
            properties: {
              category: { type: :string },
              name: { type: :string },
              branch_id: { type: :string }
            },
            required: %w[category name branch_id]
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
                     category: { type: :string },
                     name: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     branch: {
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
                         city: { type: :string },
                         address: { type: :string },
                         phone_number: { type: :string }
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

  path '/api/v1/groups/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Group ID'

    get 'Retrieve a group by ID' do
      tags 'Groups'
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
                     category: { type: :string },
                     name: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     branch: {
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
                         city: { type: :string },
                         address: { type: :string },
                         phone_number: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update a group by ID' do
      tags 'Groups'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: {
          group: {
            type: :object,
            properties: {
              category: { type: :string },
              name: { type: :string },
              branch_id: { type: :string }
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
                     category: { type: :string },
                     name: { type: :string },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     branch: {
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
                         city: { type: :string },
                         address: { type: :string },
                         phone_number: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    delete 'Delete group' do
      tags 'Groups'
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

  path '/api/v1/groups/categories' do
    get 'Get a list of group categories' do
      tags 'Groups'
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
                       id: { type: :string, example: 'builders' },
                       label: { type: :string, example: 'Builders' }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/groups/export' do
    get 'Exports groups as CSV' do
      tags 'Groups'
      security [bearerAuth: []]

      parameter name: 'categories[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of categories to filter groups by', required: false
      parameter name: 'branch_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of branch IDs to filter groups by', required: false
      parameter name: :q, in: :query, type: :string,
                description: 'A query string to search groups by name, cateogry, or branch.name',
                required: false

      produces 'text/csv'
      response '200', 'OK' do
        schema type: :string
        header 'Content-Type', 'text/csv'
        header 'Content-Disposition', 'attachment; filename=groups.csv'

        xit
      end
    end
  end
end
