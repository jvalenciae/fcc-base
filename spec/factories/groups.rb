# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    category { 1 }
    name { Faker::Name.name }
    branch
  end
end
