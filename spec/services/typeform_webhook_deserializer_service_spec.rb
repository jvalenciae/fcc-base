# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TypeformWebhookDeserializerService do
  describe '#call' do
    let(:payload) do
      {
        'event_id' => '12345',
        'form_response' => {
          'answers' => [
            { 'type' => 'date', 'date' => '2023-01-01' },
            { 'choice' => { 'label' => 'Example' } }
          ],
          'variables' => { 'question1' => 5, 'question2' => 4 },
          'hidden' => { 'survey_id' => 'survey123', 'student_id' => 'student456' }
        }
      }
    end

    it 'returns the correct attributes' do
      service = described_class.new(payload)
      response_id, date, kind_of_measurement, scores, survey_id, student_id = service.call

      expect(response_id).to eq('12345')
      expect(date).to eq('2023-01-01')
      expect(kind_of_measurement).to eq('Example')
      expect(scores).to eq({ 'question1' => 5, 'question2' => 4 })
      expect(survey_id).to eq('survey123')
      expect(student_id).to eq('student456')
    end
  end
end
