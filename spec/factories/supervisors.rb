# frozen_string_literal: true

FactoryBot.define do
  factory :supervisor do
    id_number { Faker::Number.unique.number(digits: 10) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    birthdate { Faker::Date.between(from: '1950-01-01', to: '2005-12-31') }
    phone_number { Faker::Number.number(digits: 10) }
    profession { Faker::Job.title }
    relationship { Supervisor::RELATIONSHIPS.keys.sample }
    student
  end
end
