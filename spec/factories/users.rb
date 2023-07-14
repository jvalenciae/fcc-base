# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone_number { Faker::Number.number(digits: 10) }
    country { 'CO' }
    role { 'role' }
  end
end
