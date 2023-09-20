# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersFilterService do
  # rubocop:disable RSpec/IndexedLet
  let!(:organization) { create(:organization) }
  let!(:branch) { create(:branch, organization: organization) }
  let!(:user1) { create(:user, organization: organization, branches: [branch]) }
  let!(:user2) { create(:user) }
  # rubocop:enable RSpec/IndexedLet

  before do
    create(:group, branch: branch)
  end

  describe '#call' do
    it 'applies filters to users' do
      params = {
        branch_ids: [user1.branches.first.id],
        categories: [user1.groups.first.category],
        departments: [user1.branches.first.department],
        q: user1.first_name
      }

      users = described_class.call(User.all, params)

      expect(users).to include(user1)
      expect(users).not_to include(user2)
    end

    it 'returns all users when no filters are provided' do
      params = {}

      users = described_class.call(User.all, params)

      expect(users).to include(user1, user2)
    end
  end
end
