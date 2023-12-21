# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyResponse do
  subject { create(:survey_response) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:response_id) }
    it { is_expected.to validate_presence_of(:json_response) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:kind_of_measurement) }
    it { is_expected.to validate_presence_of(:scores) }
    it { is_expected.to validate_uniqueness_of(:response_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:survey) }
    it { is_expected.to belong_to(:branch).optional(true) }
    it { is_expected.to belong_to(:student).optional(true) }
  end
end
