# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  describe 'validations' do
    subject { build(:group) }

    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category, :branch_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:branch) }
    it { is_expected.to have_many(:students).dependent(nil) }
    it { is_expected.to have_many(:group_attendances).dependent(nil) }
  end

  describe 'callbacks' do
    describe 'before_save :set_display_name' do
      let(:branch) { create(:branch, name: 'branch') }

      it 'sets a display_name' do
        group = create(:group, branch: branch, category: 'builders', name: 'name')

        expect(group.display_name).not_to be_nil
        expect(group.display_name).to eq('branch builders name')
      end
    end
  end

  describe 'constants' do
    it 'has the correct categories' do
      expect(Group::CATEGORIES).to eq({
        creators: 0,
        explorers: 1,
        builders: 2,
        promoters: 3
      }.with_indifferent_access.freeze)
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:category).with_values(Group::CATEGORIES) }
  end

  describe 'scopes' do
    describe '.search_by_q' do
      # rubocop:disable RSpec/IndexedLet
      let!(:branch1) { create(:branch, name: 'Branch One') }
      let!(:branch2) { create(:branch, name: 'Branch Two') }

      let!(:group1) { create(:group, name: '1', category: Group::CATEGORIES.keys.first, branch: branch1) }
      let!(:group2) { create(:group, name: '2', category: Group::CATEGORIES.keys.first, branch: branch2) }
      # rubocop:enable RSpec/IndexedLet

      it 'searches by name' do
        results = described_class.search_by_q('2')

        expect(results).to include(group2)
        expect(results).not_to include(group1)
      end

      it 'searches by branch name' do
        results = described_class.search_by_q('one')

        expect(results).to include(group1)
        expect(results).not_to include(group2)
      end

      it 'searches by display name' do
        results = described_class.search_by_q('Branch One creators 1')

        expect(results).to include(group1)
        expect(results).not_to include(group2)
      end
    end

    describe '.search_by_category' do
      # rubocop:disable RSpec/IndexedLet
      let!(:group1) { create(:group, name: '1', category: Group::CATEGORIES.keys.first) }
      let!(:group2) { create(:group, name: '2', category: Group::CATEGORIES.keys.last) }
      # rubocop:enable RSpec/IndexedLet

      it 'filters records by category' do
        results = described_class.search_by_category(Group::CATEGORIES.keys.first)

        expect(results).to include(group1)
        expect(results).not_to include(group2)
      end

      it 'handles partial matches' do
        results = described_class.search_by_category(Group::CATEGORIES.keys.last[1..3])

        expect(results).to include(group2)
        expect(results).not_to include(group1)
      end

      it 'returns all records when category is blank' do
        results = described_class.search_by_category(nil)

        expect(results).to include(group1, group2)
      end
    end

    describe '.by_branch_ids' do
      # rubocop:disable RSpec/IndexedLet
      let!(:branch1) { create(:branch) }
      let!(:branch2) { create(:branch) }
      let!(:group1) { create(:group, branch: branch1) }
      let!(:group2) { create(:group, branch: branch2) }
      # rubocop:enable RSpec/IndexedLet

      it 'returns groups belonging to the specified branch IDs' do
        result = described_class.by_branch_ids([branch1.id])
        expect(result).to include(group1)
        expect(result).not_to include(group2)
      end
    end

    describe '.by_categories' do
      # rubocop:disable RSpec/IndexedLet
      let!(:group1) { create(:group, category: 'creators') }
      let!(:group2) { create(:group, category: 'explorers') }
      # rubocop:enable RSpec/IndexedLet

      it 'returns groups of the specified categories' do
        result = described_class.by_categories(['creators'])
        expect(result).to include(group1)
        expect(result).not_to include(group2)
      end
    end
  end
end
