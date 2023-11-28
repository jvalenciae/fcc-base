# frozen_string_literal: true

module Api
  module V1
    module Surveys
      class WebhooksController < ApiController
        include TypeformWebhookVerificator

        skip_before_action :authenticate_user!

        def create
          response_payload = JSON.parse(request.body.read)
          response_id, date, kind_of_measurement, scores, survey_id, student_id =
            TypeformWebhookDeserializerService.call(response_payload)

          survey_response = SurveyResponse.find_or_initialize_by(
            date: date,
            kind_of_measurement: kind_of_measurement,
            survey_id: survey_id,
            student_id: student_id
          )

          survey_response.response_id = response_id
          survey_response.json_response = response_payload
          survey_response.scores = scores

          head :ok if survey_response.save!
        end
      end
    end
  end
end
