# frozen_string_literal: true

FactoryBot.define do
  factory :short_url do
    original_url { Faker::Internet.url }
    shortened_url { Faker::Internet.url }
    visits { 1 }
  end
end
