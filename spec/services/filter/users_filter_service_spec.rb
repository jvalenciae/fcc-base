# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter::UsersFilterService do
  # rubocop:disable RSpec/IndexedLet
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  # rubocop:enable RSpec/IndexedLet

  describe '#call' do
    it 'applies filters to users' do
      params = {
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
