# frozen_string_literal: true

FactoryBot.define do
  factory :ally do
    name { Faker::Company.name }
    organization
  end
end
