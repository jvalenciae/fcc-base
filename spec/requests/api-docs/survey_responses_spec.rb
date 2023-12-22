# frozen_string_literal: true

require 'swagger_helper'

describe 'SurveyReponses API' do
  path '/api/v1/survey_reponses' do
    get 'Retrieve list of survey responses' do
      tags 'SurveyReponses'
      security [bearerAuth: []]

      parameter name: 'survey_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of survey IDs to filter responses by', required: false

      parameter name: 'branch_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of branch IDs to filter responses by', required: false

      parameter name: 'group_ids[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of group IDs to filter responses by', required: false

      parameter name: 'categories[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of categories to filter responses by', required: false

      parameter name: 'gender[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of genders ["male", "female"] to filter responses by', required: false

      parameter name: 'kind_of_measurement[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :string }
      }, description: 'An array of kind_of_measurement ["Ingreso", "Salida"] to filter responses by', required: false

      parameter name: 'years[]', in: :query, style: :form, explode: true, schema: {
        type: :array,
        items: { type: :integer }
      }, description: 'An array of years [2020, 2022] to filter responses by', required: false

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
                       response_id: { type: :string },
                       date: { type: :string },
                       survey_id: { type: :string },
                       student_id: { type: :string },
                       kind_of_measurement: { type: :string }
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
