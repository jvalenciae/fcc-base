# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Supervisor do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:id_number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:profession) }
    it { is_expected.to validate_presence_of(:relationship) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end

  describe 'constants' do
    it 'has valid relationships' do
      expect(Supervisor::RELATIONSHIPS).to eq({
        father: 0,
        mother: 1,
        sibling: 2,
        cousin: 3,
        uncle: 4,
        aunt: 5
      }.with_indifferent_access)

      expect(Supervisor::RELATIONSHIPS).to be_frozen
    end
  end

  describe 'enums' do
    let(:supervisor) { build(:supervisor) }

    it {
      expect(supervisor).to define_enum_for(:relationship).with_values(Supervisor::RELATIONSHIPS)
    }
  end
end
