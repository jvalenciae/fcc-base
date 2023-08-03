# frozen_string_literal: true

require 'swagger_helper'

describe 'Passwords API' do
  path '/api/v1/auth/passwords' do
    post 'Create password reset token' do
      tags 'Authentication'

      consumes 'application/json'
      produces 'application/json'
      parameter name: :email, in: :body, type: :string, description: 'User email', required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 token: { type: :string }
               }

        xit
      end
    end
  end

  path '/api/v1/auth/passwords' do
    put 'Update password' do
      tags 'Authentication'

      consumes 'application/json'
      produces 'application/json'
      parameter name: :token, in: :query, type: :string,
                description: 'Password reset token received in the email', required: true
      parameter name: :password, in: :body, type: :string,
                description: 'New password', required: true
      parameter name: :password_confirmation, in: :body, type: :string,
                description: 'Password confirmation', required: true

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
