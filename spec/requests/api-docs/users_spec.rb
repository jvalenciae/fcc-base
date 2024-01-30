# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  path '/api/v1/users' do
    get 'List users' do
      tags 'Users'
      security [bearerAuth: []]

      parameter name: :role, in: :query, type: :string,
                description: 'A query string to filter users by role',
                required: false
      parameter name: :q, in: :query, type: :string,
                description: 'A query string to search users by first name, last name, or phone number',
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
                       id: { type: :string },
                       email: { type: :string },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       country: {
                         type: :object,
                         properties: {
                           code: { type: :string },
                           name: { type: :string }
                         }
                       },
                       role: { type: :string },
                       last_sign_in_at: { type: :string }
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

    post 'Create user' do
      tags 'Users'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              phone_number: { type: :string },
              country: { type: :string, example: 'CO' },
              role: { type: :string }
            }
          }
        },
        required: %w[first_name last_name email password phone_number country role]
      }

      response '201', 'Created' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     role: { type: :string },
                     last_sign_in_at: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show user' do
      tags 'Users'
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
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     role: { type: :string },
                     last_sign_in_at: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update user' do
      tags 'Users'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              country: {
                type: :object,
                properties: {
                  code: { type: :string },
                  name: { type: :string }
                }
              },
              role: { type: :string }
            }
          }
        },
        required: %w[first_name last_name email password phone_number country role]
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     country: {
                       type: :object,
                       properties: {
                         code: { type: :string },
                         name: { type: :string }
                       }
                     },
                     role: { type: :string },
                     last_sign_in_at: { type: :string }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    delete 'Delete user' do
      tags 'Users'
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
