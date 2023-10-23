# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsExportService do
  # rubocop:disable RSpec/IndexedLet
  let(:group1) { create(:group, category: 'creators') }
  let(:group2) { create(:group, category: 'explorers') }
  # rubocop:enable RSpec/IndexedLet

  let(:groups) { [group1, group2] }

  describe '#call' do
    it 'generates a CSV with group information' do
      csv_result = described_class.call(groups)

      expect(csv_result).to include(Group.take.attributes.keys.join(','))
      expect(csv_result).to include(group1.attributes.values.join(','))
      expect(csv_result).to include(group2.attributes.values.join(','))
    end
  end
end
