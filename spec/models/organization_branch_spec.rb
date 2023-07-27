# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationBranch do
  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to belong_to(:branch) }
  end
end
