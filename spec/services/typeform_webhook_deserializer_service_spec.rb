# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TypeformWebhookDeserializerService do
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

    it 'returns the correct attributes' do
      service = described_class.new(payload)
      response_id, date, kind_of_measurement, scores, survey_id, branch_id, student_id, single_responses = service.call

      expect(response_id).to eq('12345')
      expect(date).to eq('2023-01-01')
      expect(kind_of_measurement).to eq('Example')
      expect(scores).to eq({ 'question1' => 5, 'question2' => 4 })
      expect(survey_id).to eq('survey123')
      expect(branch_id).to eq('branch456')
      expect(student_id).to eq('student456')
      expect(single_responses).to be_a(Array)
      expect(single_responses.first).to be_a(SingleResponseInput)
    end
  end
end
