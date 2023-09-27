# frozen_string_literal: true

require 'swagger_helper'

describe 'Students API' do
  path '/api/v1/students' do
    get 'Retrieve list of students' do
      tags 'Students'
      security [bearerAuth: []]

      parameter name: 'branch_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of branches IDs to filter students by', required: false

      parameter name: 'categories[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of categories to filter students by', required: false

      parameter name: 'group_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of groups IDs to filter students by', required: false

      parameter name: 'statuses[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of statuses to filter students by', required: false

      parameter name: 'tshirt_sizes[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of tshirt_sizes to filter students by', required: false

      parameter name: 'shorts_sizes[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of shorts_sizes to filter students by', required: false

      parameter name: 'socks_sizes[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of socks_sizes to filter students by', required: false

      parameter name: 'shoe_sizes[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of shoe_sizes to filter students by', required: false

      parameter name: 'health_coverages[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of health_coverages to filter students by', required: false

      parameter name: :beneficiary_of_another_foundation, in: :query, type: :boolean, required: false
      parameter name: :displaced, in: :query, type: :boolean, required: false
      parameter name: :lives_with_reinserted_familiar, in: :query, type: :boolean, required: false
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
                       id_number: { type: :string },
                       name: { type: :string },
                       gender: { type: :string },
                       status: { type: :string },
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
                       },
                       group: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           category: { type: :string }
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

    post 'Create a new student' do
      tags 'Students'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :student, in: :body, schema: {
        type: :object,
        properties: {
          student: {
            type: :object,
            properties: {
              id_number: { type: :string },
              name: { type: :string },
              birthplace: { type: :string },
              birthdate: { type: :string, format: :date, example: 'DD-MM-YYYY' },
              gender: { type: :string },
              tshirt_size: { type: :integer },
              shorts_size: { type: :integer },
              socks_size: { type: :integer },
              shoe_size: { type: :integer },
              favourite_colour: { type: :string },
              favourite_food: { type: :string },
              favourite_place: { type: :string },
              favourite_sport: { type: :string },
              feeling_when_playing_soccer: { type: :string },
              country: { type: :string, example: 'CO' },
              city: { type: :string },
              neighborhood: { type: :string },
              address: { type: :string },
              school: { type: :string },
              extracurricular_activities: { type: :string },
              health_coverage: { type: :string },
              displaced: { type: :boolean },
              desplacement_origin: { type: :string },
              desplacement_reason: { type: :string },
              lives_with_reinserted_familiar: { type: :boolean },
              program: { type: :string },
              beneficiary_of_another_foundation: { type: :boolean },
              status: { type: :string },
              withdrawal_date: { type: :string, format: :date, example: 'DD-MM-YYYY' },
              withdrawal_reason: { type: :string },
              group_id: { type: :string },
              branch_id: { type: :string },
              supervisors_attributes: {
                type: :object,
                properties: {
                  id_number: { type: :string },
                  name: { type: :string },
                  email: { type: :string },
                  birthdate: { type: :string, format: :date, example: 'DD-MM-YYYY' },
                  phone_number: { type: :string },
                  profession: { type: :string },
                  relationship: { type: :string }
                }
              }
            },
            required: %w[id_number name birthplace birthdate gender tshirt_size shorts_size socks_size shoe_size
                         favourite_colour favourite_food favourite_sport favourite_place feeling_when_playing_soccer
                         city country neighborhood address school extracurricular_activities health_coverage]
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
                     id_number: { type: :string },
                     name: { type: :string },
                     gender: { type: :string },
                     status: { type: :string },
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
                     },
                     group: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         category: { type: :string }
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

  path '/api/v1/students/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Student ID'

    get 'Retrieve a student by ID' do
      tags 'Students'
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
                     id_number: { type: :string },
                     name: { type: :string },
                     gender: { type: :string },
                     status: { type: :string },
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
                     },
                     group: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         category: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    put 'Update a student by ID' do
      tags 'Students'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :student, in: :body, schema: {
        type: :object,
        properties: {
          student: {
            type: :object,
            properties: {
              id_number: { type: :string },
              name: { type: :string },
              birthplace: { type: :string },
              birthdate: { type: :string, format: :date, example: 'DD-MM-YYYY' },
              gender: { type: :string },
              tshirt_size: { type: :integer },
              shorts_size: { type: :integer },
              socks_size: { type: :integer },
              shoe_size: { type: :integer },
              favourite_colour: { type: :string },
              favourite_food: { type: :string },
              favourite_place: { type: :string },
              favourite_sport: { type: :string },
              feeling_when_playing_soccer: { type: :string },
              country: { type: :string, example: 'CO' },
              city: { type: :string },
              neighborhood: { type: :string },
              address: { type: :string },
              school: { type: :string },
              extracurricular_activities: { type: :string },
              health_coverage: { type: :string },
              displaced: { type: :boolean },
              desplacement_origin: { type: :string },
              desplacement_reason: { type: :string },
              lives_with_reinserted_familiar: { type: :boolean },
              program: { type: :string },
              beneficiary_of_another_foundation: { type: :boolean },
              status: { type: :string },
              withdrawal_date: { type: :string, format: :date, example: 'DD-MM-YYYY' },
              withdrawal_reason: { type: :string },
              group_id: { type: :string },
              branch_id: { type: :string },
              supervisors_attributes: {
                type: :object,
                properties: {
                  id_number: { type: :string },
                  name: { type: :string },
                  email: { type: :string },
                  birthdate: { type: :string, format: :date, example: 'DD-MM-YYYY' },
                  phone_number: { type: :string },
                  profession: { type: :string },
                  relationship: { type: :string }
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
                     id_number: { type: :string },
                     name: { type: :string },
                     gender: { type: :string },
                     status: { type: :string },
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
                     },
                     group: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         category: { type: :string }
                       }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        xit
      end
    end

    delete 'Delete student' do
      tags 'Students'
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
