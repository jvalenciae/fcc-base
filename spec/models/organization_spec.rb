require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject(:organization) { create(:organization) }

  describe 'validations' do
    it 'validates presence' do
      expect(organization).to validate_presence_of(:name)
      expect(organization).to validate_presence_of(:country)
      expect(organization).to validate_presence_of(:report_id)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(organization).to have_many(:branches).dependent(:destroy)
    end
  end
end