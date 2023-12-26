# frozen_string_literal: true

FactoryBot.define do
  factory :single_response_input do
    question { 'question' }
    answer { 'answer' }
    survey_response
  end
end
