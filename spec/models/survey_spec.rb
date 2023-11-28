# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:form_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:survey_responses).dependent(nil) }
  end
end
