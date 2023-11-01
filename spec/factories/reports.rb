# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    name { 'report' }
    quicksight_embed_src { 'embed_src' }
    quicksight_dashboard_id { 'dashboard_id' }
    organization
  end
end
