# frozen_string_literal: true

require 'swagger_helper'

describe 'Surveys API' do
  path '/api/v1/surveys' do
    get 'Retrieve list of surveys' do
      tags 'Surveys'
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
                       key: { type: :string },
                       form_id: { type: :string },
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
                           }
                         }
                       },
                       default: { type: :boolean }
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

    post 'Create a new survey' do
      tags 'Surveys'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :survey, in: :body, schema: {
        type: :object,
        properties: {
          survey: {
            type: :object,
            properties: {
              name: { type: :string },
              key: { type: :string },
              form_id: { type: :string },
              organization_id: { type: :string },
              default: { type: :boolean }
            },
            required: %w[name description form_id organization_id]
          }
        }
      }

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
                       key: { type: :string },
                       form_id: { type: :string },
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
                           }
                         }
                       },
                       default: { type: :boolean }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end
  end

  path '/api/v1/surveys/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Survey ID'

    get 'Retrieve a survey by ID' do
      tags 'Surveys'
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
                       id: { type: :string },
                       name: { type: :string },
                       key: { type: :string },
                       form_id: { type: :string },
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
                           }
                         }
                       },
                       default: { type: :boolean }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update a survey by ID' do
      tags 'Surveys'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :branch, in: :body, schema: {
        type: :object,
        properties: {
          survey: {
            type: :object,
            properties: {
              name: { type: :string },
              key: { type: :string },
              form_id: { type: :string },
              organization_id: { type: :string },
              default: { type: :boolean }
            }
          }
        }
      }

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
                       key: { type: :string },
                       form_id: { type: :string },
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
                           }
                         }
                       },
                       default: { type: :boolean }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    path '/api/v1/surveys/default' do
      get 'List of default surveys' do
        tags 'Surveys'
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
                         id: { type: :string },
                         name: { type: :string },
                         key: { type: :string },
                         form_id: { type: :string },
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
                             }
                           }
                         },
                         default: { type: :boolean }
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
    end

    path '/api/v1/surveys/ad_hoc' do
      get 'Retrieve list of ad_hoc surveys' do
        tags 'Surveys'
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
                         key: { type: :string },
                         form_id: { type: :string },
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
                             }
                           }
                         },
                         default: { type: :boolean }
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
    end
  end
end
