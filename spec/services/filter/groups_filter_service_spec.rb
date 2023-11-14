# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter::GroupsFilterService do
  # rubocop:disable RSpec:IndexedLet
  let!(:branch1) { create(:branch, name: 'branch one') }
  let!(:branch2) { create(:branch, name: 'branch two') }
  let!(:group1) { create(:group, branch: branch1) }
  let!(:group2) { create(:group, branch: branch2) }
  # rubocop:enable RSpec:IndexedLet

  before do
    create_list(:group, 5)
  end

  # rubocop:disable RSpec:MultipleMemoizedHelpers
  describe '#call' do
    it 'filters groups based on provided parameters' do
      params = {
        branch_ids: [branch1.id],
        categories: [group1.category],
        q: group1.category
      }

      filtered_groups = described_class.call(Group.all, params)

      expect(filtered_groups).to contain_exactly(group1)
    end
  end
  # rubocop:enable RSpec:MultipleMemoizedHelpers
end
