# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllyBranch do
  describe 'associations' do
    it { is_expected.to belong_to(:ally) }
    it { is_expected.to belong_to(:branch) }
  end
end
