# frozen_string_literal: true

FactoryBot.define do
  factory :branch do
    name { Faker::Name.name }
    country { 'CO' }
    city { CS.states(:CO).keys.flat_map { |state| CS.cities(state, :CO) }.sample }
    address { Faker::Address.full_address }
    phone_number { Faker::Number.number(digits: 10) }
    organizations { build_list(:organization, 1) }
  end
end
