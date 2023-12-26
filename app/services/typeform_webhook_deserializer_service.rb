# frozen_string_literal: true

class TypeformWebhookDeserializerService < ApplicationService
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def call
    find_attributes(payload)
  end

  private

  # rubocop:disable Metrics/AbcSize
  def find_attributes(payload)
    response_id = payload['event_id']
    date = payload['form_response']['answers'].find { |ans| ans['type'] == 'date' }['date']
    kind_of_measurement = payload['form_response']['answers']&.second.try(:[], 'choice').try(:[], 'label')
    scores = payload['form_response']['variables']
    survey_id = payload['form_response']['hidden']['survey_id']
    branch_id = payload['form_response']['hidden'].try(:[], 'branch_id')
    student_id = payload['form_response']['hidden'].try(:[], 'student_id')
    single_responses = SingleResponseInputBuilderService.call(payload)

    [response_id, date, kind_of_measurement, scores, survey_id, branch_id, student_id, single_responses]
  end
  # rubocop:enable Metrics/AbcSize
end
