# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ally do
  subject(:ally) { create(:ally) }

  describe 'validations' do
    it 'validates presence' do
      expect(ally).to validate_presence_of(:name)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(ally).to belong_to(:organization)
      expect(ally).to have_many(:ally_branches).dependent(nil)
      expect(ally).to have_many(:branches).through(:ally_branches)
    end
  end

  describe 'scopes' do
    describe '.search_by_q' do
      # rubocop:disable RSpec/IndexedLet
      let!(:ally1) { create(:ally, name: 'John') }
      let!(:ally2) { create(:ally, name: 'Jane') }
      let!(:ally3) { create(:ally, name: 'Alice') }
      # rubocop:enable RSpec/IndexedLet

      it 'returns users matching the query' do
        expect(described_class.search_by_q('John')).to contain_exactly(ally1)
        expect(described_class.search_by_q('Jane')).to contain_exactly(ally2)
        expect(described_class.search_by_q('J')).to contain_exactly(ally1, ally2)
      end

      it 'ignores accents in the search' do
        expect(described_class.search_by_q('Álice')).to contain_exactly(ally3)
      end
    end

    describe '.by_organization_ids' do
      let!(:org) { create(:organization) }
      let!(:ally) { create(:ally) }
      let!(:org_allies) { create_list(:ally, 3, organization: org) }

      it 'finds allies by given organizations' do
        expect(described_class.by_organization_ids([org.id])).to match_array org_allies
        expect(described_class.by_organization_ids([org.id])).not_to include(ally)
      end

      it 'finds all if no organization given' do
        expect(described_class.by_organization_ids(nil)).to match_array described_class.all
      end
    end
  end
end
