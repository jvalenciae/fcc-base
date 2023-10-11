# frozen_string_literal: true

FactoryBot.define do
  factory :student_attendance do
    date { Time.zone.today }
    present { true }
    group_attendance
    student
  end
end
