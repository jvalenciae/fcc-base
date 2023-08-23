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

  describe 'scopes' do
    describe '.search_by_q' do
      # rubocop:disable RSpec/IndexedLet
      let!(:organization1) { create(:organization, name: 'John') }
      let!(:organization2) { create(:organization, name: 'Jane') }
      let!(:organization3) { create(:organization, name: 'Alice Jane') }
      # rubocop:enable RSpec/IndexedLet

      it 'returns organizations matching the query' do
        expect(described_class.search_by_q('John')).to eq([organization1])
        expect(described_class.search_by_q('Jane')).to eq([organization2, organization3])
        expect(described_class.search_by_q('Alice')).to eq([organization3])
      end

      it 'ignores accents in the search' do
        expect(described_class.search_by_q('Álice')).to eq([organization3])
      end
    end
  end
end
