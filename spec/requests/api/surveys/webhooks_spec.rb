# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Surveys::Webhooks' do
  describe 'POST #create' do
    let(:survey) { create(:survey) }
    let(:student) { create(:student) }
    let(:valid_payload) do
      {
        event_id: 'valid_response_id',
        form_response: {
          variables: [
            {
              key: 'autonomy',
              type: 'number',
              number: 8
            }
          ],
          answers: [
            {
              type: 'date',
              date: '2023-01-01'
            },
            {
              choice: {
                label: 'kind_of_measurement'
              }
            }
          ],
          hidden: {
            survey_id: survey.id,
            student_id: student.id,
            env: 'test'
          }
        }
      }
    end

    context 'when the signature is valid' do
      let(:encoded_signature) { Base64.strict_encode64('valid_signature') }

      before do
        allow(OpenSSL::HMAC).to receive(:digest).and_return('valid_signature')
      end

      it 'creates a new survey response' do
        post '/api/v1/surveys/webhook', params: valid_payload,
                                        env: { 'HTTP_TYPEFORM_SIGNATURE' => "sha256=#{encoded_signature}" }, as: :json

        expect(response).to have_http_status(:ok)
        expect(SurveyResponse.count).to eq(1)
      end
    end

    context 'when the signature is not valid' do
      let(:encoded_signature) { Base64.strict_encode64('invalid_signature') }

      before do
        allow(OpenSSL::HMAC).to receive(:digest).and_return('valid_signature')
      end

      it 'does not creates a new survey response' do
        post '/api/v1/surveys/webhook', params: valid_payload,
                                        env: { 'HTTP_TYPEFORM_SIGNATURE' => "sha256=#{encoded_signature}" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(SurveyResponse.count).to eq(0)
      end
    end

    context 'when the env is different' do
      let(:encoded_signature) { Base64.strict_encode64('valid_signature') }

      before do
        valid_payload[:form_response][:hidden][:env] = 'wrong_env'
        allow(OpenSSL::HMAC).to receive(:digest).and_return('valid_signature')
      end

      it 'returns an error response' do
        post '/api/v1/surveys/webhook', params: valid_payload,
                                        env: { 'HTTP_TYPEFORM_SIGNATURE' => "sha256=#{encoded_signature}" }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(SurveyResponse.count).to eq(0)
      end
    end
  end
end
