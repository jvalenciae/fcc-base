# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'title' }
    description { 'description' }
    due_date { '01-01-2025' }
    status { 'pending' }
    user
  end
end
