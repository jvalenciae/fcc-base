# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SingleResponseInputBuilderService do
  describe '#call' do
    let(:payload) do
      {
        'event_id' => '12345',
        'form_response' => {
          'definition' => {
            'fields' => [
              {
                'type' => 'multiple_choice',
                'title' => 'Example'
              }
            ]
          },
          'answers' => [
            {
              'type' => 'date',
              'date' => '2023-01-01'
            },
            {
              'type' => 'choice',
              'choice' => {
                'label' => 'Example'
              }
            }
          ],
          'variables' => { 'question1' => 5, 'question2' => 4 },
          'hidden' => { 'survey_id' => 'survey123', 'branch_id' => 'branch456', 'student_id' => 'student456' }
        }
      }
    end

    it 'returns only multiple choice single responses' do
      single_responses = described_class.call(payload)
      expect(single_responses).to be_a(Array)
      expect(single_responses.first).to be_a(SingleResponseInput)
    end
  end
end
