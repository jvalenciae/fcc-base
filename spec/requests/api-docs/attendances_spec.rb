# frozen_string_literal: true

require 'swagger_helper'

describe 'Attendances API' do
  path '/api/v1/attendances' do
    get 'Retrieve list of attendances' do
      tags 'Attendances'
      security [bearerAuth: []]

      parameter name: 'branch_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of branch IDs to filter attendances by', required: false
      parameter name: 'group_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of group IDs to filter attendances by', required: false
      parameter name: :date, in: :query, type: :string, description: 'Date: YYYY-MM-DD'

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
                       date: { type: :string },
                       group: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           category: { type: :string },
                           name: { type: :string },
                           branch: {
                             type: :object,
                             properties: {
                               id: { type: :string },
                               name: { type: :string }
                             }
                           },
                           organization: {
                             type: :object,
                             properties: {
                               id: { type: :string },
                               name: { type: :string }
                             }
                           }
                         }
                       },
                       student_attendances: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :string },
                             id_number: { type: :string },
                             date: { type: :string },
                             present: { type: :boolean },
                             student: {
                               type: :object,
                               properties: {
                                 id: { type: :string },
                                 name: { type: :string }
                               }
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

    post 'Create a new attendance' do
      tags 'Attendances'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :group_attendance, in: :body, schema: {
        type: :object,
        properties: {
          group_attendance: {
            type: :object,
            properties: {
              date: { type: :string },
              group_id: { type: :string },
              attendances: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    student_id: { type: :string },
                    present: { type: :boolean }
                  }
                }
              }
            },
            required: %w[date group_id attendances]
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 date: { type: :string },
                 group: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     category: { type: :string },
                     name: { type: :string },
                     branch: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     }
                   }
                 },
                 student_attendances: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       id_number: { type: :string },
                       date: { type: :string },
                       present: { type: :boolean },
                       student: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string }
                         }
                       }
                     }
                   }
                 }
               }

        xit
      end
    end
  end

  path '/api/v1/attendances/{id}' do
    parameter name: :id, in: :path, type: :integer,
              description: 'Attendance ID'

    get 'Retrieve an attendance by ID' do
      tags 'Attendances'
      security [bearerAuth: []]

      produces 'application/json'
      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 date: { type: :string },
                 group: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     category: { type: :string },
                     name: { type: :string },
                     branch: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     }
                   }
                 },
                 student_attendances: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       date: { type: :string },
                       id_number: { type: :string },
                       present: { type: :boolean },
                       student: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string }
                         }
                       }
                     }
                   }
                 }
               }

        xit
      end
    end

    put 'Update an attendance by ID' do
      tags 'Attendances'
      security [bearerAuth: []]

      consumes 'application/json'
      produces 'application/json'
      parameter name: :ally, in: :body, schema: {
        type: :object,
        properties: {
          group_attendance: {
            type: :object,
            properties: {
              date: { type: :string },
              attendances: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    student_id: { type: :string },
                    present: { type: :boolean }
                  }
                }
              }
            },
            required: %w[date attendances]
          }
        }
      }

      response '200', 'OK' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 date: { type: :string },
                 group: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     category: { type: :string },
                     name: { type: :string },
                     branch: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     },
                     organization: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         name: { type: :string }
                       }
                     }
                   }
                 },
                 student_attendances: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       date: { type: :string },
                       id_number: { type: :string },
                       present: { type: :boolean },
                       student: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string }
                         }
                       }
                     }
                   }
                 }
               }

        xit
      end
    end

    delete 'Delete attendace' do
      tags 'Attendances'
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
