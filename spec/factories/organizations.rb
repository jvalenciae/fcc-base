# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    country { 'CO' }
    report_id { '123456' }
  end
end
