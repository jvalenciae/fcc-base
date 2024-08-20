require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { expect(subject).to belong_to(:user) }
  end
end
