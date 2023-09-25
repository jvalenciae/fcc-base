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
