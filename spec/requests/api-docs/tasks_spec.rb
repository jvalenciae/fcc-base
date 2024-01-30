# frozen_string_literal: true

require 'swagger_helper'

describe 'Tasks API' do
  path '/api/v1/tasks' do
    get 'List tasks' do
      tags 'Tasks'
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
                       title: { type: :string },
                       description: { type: :string },
                       due_date: { type: :date },
                       status: { type: :string },
                       overdue: { type: :boolean }
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

    post 'Create task' do
      tags 'Tasks'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              due_date: { type: :string },
              status: { type: :string },
              user_id: { type: :string }
            }
          }
        },
        required: %w[title description due_date status user_id]
      }

      response '201', 'Created' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     title: { type: :string },
                     description: { type: :string },
                     due_date: { type: :date },
                     status: { type: :string },
                     overdue: { type: :boolean }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show task' do
      tags 'Tasks'
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
                     title: { type: :string },
                     description: { type: :string },
                     due_date: { type: :date },
                     status: { type: :string },
                     overdue: { type: :boolean }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update task' do
      tags 'Tasks'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              due_date: { type: :string },
              status: { type: :string },
              user_id: { type: :string }
            }
          }
        },
        required: %w[title description due_date status user_id]
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     title: { type: :string },
                     description: { type: :string },
                     due_date: { type: :date },
                     status: { type: :string },
                     overdue: { type: :boolean }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    delete 'Delete task' do
      tags 'Tasks'
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
