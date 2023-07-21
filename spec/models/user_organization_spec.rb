# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserOrganization do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:organization) }
  end
end