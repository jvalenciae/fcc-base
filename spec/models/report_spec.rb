# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report do
  subject(:report) { create(:report) }

  describe 'validations' do
    it 'validates presence' do
      expect(report).to validate_presence_of(:name)
      expect(report).to validate_presence_of(:quicksight_embed_src)
      expect(report).to validate_presence_of(:quicksight_dashboard_id)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(report).to belong_to(:organization)
    end
  end
end
