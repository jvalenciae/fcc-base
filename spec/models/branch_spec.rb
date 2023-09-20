# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Branch do
  subject(:branch) { create(:branch) }

  describe 'validations' do
    it 'validates presence' do
      expect(branch).to validate_presence_of(:name)
      expect(branch).to validate_presence_of(:country)
      expect(branch).to validate_presence_of(:department)
      expect(branch).to validate_presence_of(:city)
      expect(branch).to validate_presence_of(:address)
      expect(branch).to validate_presence_of(:phone_number)
    end

    describe '#validate_allies_belongs_to_organization' do
      let(:user) { create(:user) }
      let(:organization) { create(:organization) }
      let(:valid_ally) { create(:ally, organization: organization) }
      let(:invalid_ally) { create(:ally) }

      context 'when all allies belong to branch organization' do
        before do
          branch.organization = organization
          branch.allies << valid_ally
        end

        it 'does not add errors' do
          branch.valid?
          expect(branch.errors[:allies]).to be_empty
        end
      end

      context 'when some allies do not belong to branch organization' do
        before do
          branch.organization = organization
          branch.allies << invalid_ally
        end

        it 'adds an error message' do
          branch.valid?
          expect(branch.errors[:allies]).to include("Some allies don't belong to the branch's organization")
        end
      end

      context 'when branch has no allies' do
        it 'does not add errors' do
          branch.valid?
          expect(branch.errors[:branches]).to be_empty
        end
      end
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(branch).to belong_to(:organization)
      expect(branch).to have_many(:user_branches).dependent(nil)
      expect(branch).to have_many(:users).through(:user_branches)
      expect(branch).to have_many(:ally_branches).dependent(:destroy)
      expect(branch).to have_many(:allies).through(:ally_branches)
      expect(branch).to have_many(:groups).dependent(nil)
    end
  end

  describe 'scopes' do
    let!(:org) { create(:organization) }
    let!(:branch) { create(:branch, name: 'Some Random Name') }
    let!(:org_branches) { create_list(:branch, 3, name: 'Some Random Name', organization: org) }

    describe '::by_organizations' do
      it 'finds branches by given organizations' do
        expect(described_class.by_organization_ids([org.id])).to match_array org_branches
        expect(described_class.by_organization_ids([org.id])).not_to include(branch)
      end
    end

    describe '.search_by_q' do
      # rubocop:disable RSpec/IndexedLet
      let!(:branch1) { create(:branch, name: 'John') }
      let!(:branch2) { create(:branch, name: 'Jane') }
      let!(:branch3) { create(:branch, name: 'Alice Jane') }
      # rubocop:enable RSpec/IndexedLet

      it 'returns organizations matching the query' do
        expect(described_class.search_by_q('John')).to contain_exactly(branch1)
        expect(described_class.search_by_q('Jane')).to contain_exactly(branch2, branch3)
        expect(described_class.search_by_q('Alice')).to contain_exactly(branch3)
      end

      it 'ignores accents in the search' do
        expect(described_class.search_by_q('Álice')).to contain_exactly(branch3)
      end
    end
  end
end
