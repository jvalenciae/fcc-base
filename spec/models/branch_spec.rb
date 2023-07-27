# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Branch do
  subject(:branch) { create(:branch) }

  describe 'validations' do
    it 'validates presence' do
      expect(branch).to validate_presence_of(:name)
      expect(branch).to validate_presence_of(:country)
      expect(branch).to validate_presence_of(:city)
      expect(branch).to validate_presence_of(:address)
      expect(branch).to validate_presence_of(:phone_number)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(branch).to have_many(:organization_branches).dependent(:destroy)
      expect(branch).to have_many(:organizations).through(:organization_branches)
      expect(branch).to have_many(:user_branches).dependent(:destroy)
      expect(branch).to have_many(:users).through(:user_branches)
    end
  end

  describe 'scopes' do
    let!(:org) { create(:organization) }
    let!(:branch) { create(:branch) }
    let!(:org_branches) { create_list(:branch, 3, organizations: [org]) }

    describe '::by_organizations' do
      it 'finds branches by given organizations' do
        expect(described_class.by_organization_ids([org.id])).to match_array org_branches
        expect(described_class.by_organization_ids([org.id])).not_to include(branch)
      end
    end
  end
end
