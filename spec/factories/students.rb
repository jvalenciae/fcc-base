# frozen_string_literal: true

FactoryBot.define do
  factory :student do
    id_number { Faker::Number.unique.number(digits: 10).to_s }
    name { Faker::Name.name }
    birthplace { 'CO' }
    birthdate { Faker::Date.between(from: '2005-01-01', to: '2015-12-31') }
    gender { Student::GENDERS.keys.sample }
    height { rand(100..170) }
    weight { rand(20..70) }
    tshirt_size { rand(10..30) }
    shorts_size { rand(10..30) }
    socks_size { rand(10..30) }
    shoe_size { rand(10..30) }
    grade { rand(1..11) }
    favourite_colour { Faker::Color.color_name }
    favourite_food { Faker::Food.dish }
    favourite_sport { Faker::Sport.sport }
    favourite_place { Faker::Nation.capital_city }
    feeling_when_playing_soccer { 'idk' }
    country { 'CO' }
    department { 'Atlantico' }
    city { 'Barranquilla' }
    neighborhood { 'neighborhood' }
    address { 'Address' }
    school { 'school' }
    extracurricular_activities { 'activities' }
    health_coverage { Student::HEALTH_COVERAGES.keys.sample }
    displaced { false }
    beneficiary_of_another_foundation { false }
    status { Student::STATUSES.keys.sample }
    group
    branch { group.branch }
  end
end
