# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter::BranchesFilterService do
  # rubocop:disable RSpec:IndexedLet
  let!(:branch1) { create(:branch, name: 'branch one') }
  let!(:branch2) { create(:branch, name: 'branch two') }
  # rubocop:enable RSpec:IndexedLet

  before do
    create_list(:branch, 5)
  end

  # rubocop:disable RSpec:MultipleMemoizedHelpers
  describe '#call' do
    it 'filters branches based on provided parameters' do
      params = {
        organization_ids: [branch1.organization_id],
        departments: [branch1.department],
        countries: [branch1.country],
        q: branch1.name
      }

      filtered_branches = described_class.call(Branch.all, params)

      expect(filtered_branches).to contain_exactly(branch1)
    end
  end
  # rubocop:enable RSpec:MultipleMemoizedHelpers
end
