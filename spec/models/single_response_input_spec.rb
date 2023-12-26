# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SingleResponseInput do
  subject { create(:single_response_input) }

  describe 'associations' do
    it { is_expected.to belong_to(:survey_response) }
  end
end
