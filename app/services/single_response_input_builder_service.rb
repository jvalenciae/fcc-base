# frozen_string_literal: true

class SingleResponseInputBuilderService < ApplicationService
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def call
    build_single_responses(payload)
  end

  private

  def build_single_responses(payload)
    fields, answers = fetch_fields_and_answers(payload)

    single_responses = []
    fields.each_with_index do |field, index|
      question = field['title']
      answer = answers[index]['choice']['label']
      single_responses << SingleResponseInput.new(question: question, answer: answer)
    end

    single_responses
  end

  def fetch_fields_and_answers(payload)
    # Only save multiple choice questions
    fields = payload['form_response']['definition']['fields'].select { |field| field['type'] == 'multiple_choice' }
    answers = payload['form_response']['answers'].select { |answer| answer['type'] == 'choice' }
    [fields, answers]
  end
end
