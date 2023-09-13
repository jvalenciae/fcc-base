# frozen_string_literal: true

FactoryBot.define do
  factory :branch do
    name { Faker::Name.name }
    country { 'CO' }
    department { 'ATL' }
    city { CS.states(:CO).keys.flat_map { |state| CS.cities(state, :CO) }.sample }
    address { Faker::Address.full_address }
    phone_number { Faker::Number.number(digits: 10) }
    organization
  end
end
