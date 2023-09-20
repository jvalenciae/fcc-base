# frozen_string_literal: true

require 'swagger_helper'

describe 'Sessions API' do
  path '/api/v1/auth/sign_in' do
    post 'Sign in' do
      tags 'Authentication'

      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password' }
            },
            required: %w[email password]
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
                     last_sign_in_at: { type: :string },
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
                           },
                           report_id: { type: :string },
                           branches: {
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
                                 phone_number: { type: :string }
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
  end

  path '/api/v1/auth/sign_out' do
    delete 'Sign out' do
      tags 'Authentication'
      security [bearerAuth: []]

      produces 'application/json'

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string }
               }

        xit
      end
    end
  end
end
