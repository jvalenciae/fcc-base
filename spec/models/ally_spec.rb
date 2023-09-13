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
end
