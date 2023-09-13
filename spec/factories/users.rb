# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'Password123!' }
    phone_number { Faker::Number.number(digits: 10) }
    country { 'CO' }
    role { 'trainer' }
    organization

    trait :super_admin do
      role { User::SUPER_ADMIN_ROLES.keys.first }
    end

    trait :admin do
      role { User::ADMIN_ROLES.keys.first }
    end
  end
end
