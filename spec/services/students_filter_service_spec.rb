# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsFilterService do
  # rubocop:disable RSpec:IndexedLet
  let!(:branch1) { create(:branch) }
  let!(:branch2) { create(:branch) }
  let!(:group1) { create(:group, branch: branch1) }
  let!(:group2) { create(:group, branch: branch2) }
  let!(:student1) { create(:student, branch: branch1, group: group1, status: 'active') }
  let!(:student2) { create(:student, branch: branch2, group: group2, status: 'withdrawn') }
  # rubocop:enable RSpec:IndexedLet

  before do
    create_list(:student, 5)
  end

  # rubocop:disable RSpec:MultipleMemoizedHelpers
  describe '#call' do
    it 'filters students based on provided parameters' do
      params = {
        branch_ids: [branch1.id],
        group_ids: [group1.id],
        statuses: ['active']
      }

      filtered_students = described_class.call(Student.all, params)

      expect(filtered_students).to contain_exactly(student1)
    end

    it 'applies filters correctly' do
      params = {
        branch_ids: [branch2.id],
        group_ids: [group2.id],
        statuses: ['withdrawn']
      }

      filtered_students = described_class.call(Student.all, params)

      expect(filtered_students).to contain_exactly(student2)
    end
  end
  # rubocop:enable RSpec:MultipleMemoizedHelpers
end
