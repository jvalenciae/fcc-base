# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { create(:organization) }

  describe 'validations' do
    it 'validates presence' do
      expect(organization).to validate_presence_of(:name)
      expect(organization).to validate_presence_of(:country)
      expect(organization).to validate_presence_of(:report_id)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(organization).to have_many(:organization_branches).dependent(:destroy)
      expect(organization).to have_many(:branches).through(:organization_branches)
      expect(organization).to have_many(:user_organizations).dependent(:destroy)
      expect(organization).to have_many(:users).through(:user_organizations)
    end
  end
end
