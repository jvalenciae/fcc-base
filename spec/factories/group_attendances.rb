# frozen_string_literal: true

FactoryBot.define do
  factory :group_attendance do
    date { Time.zone.today }
    group
  end
end
