# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    name { 'survey' }
    key { 'key' }
    form_id { 'form_id' }
    organization
  end
end
