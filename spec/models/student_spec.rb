# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:id_number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:birthplace) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:tshirt_size) }
    it { is_expected.to validate_presence_of(:shorts_size) }
    it { is_expected.to validate_presence_of(:socks_size) }
    it { is_expected.to validate_presence_of(:shoe_size) }
    it { is_expected.to validate_presence_of(:favourite_colour) }
    it { is_expected.to validate_presence_of(:favourite_food) }
    it { is_expected.to validate_presence_of(:favourite_sport) }
    it { is_expected.to validate_presence_of(:favourite_place) }
    it { is_expected.to validate_presence_of(:feeling_when_playing_soccer) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:neighborhood) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:school) }
    it { is_expected.to validate_presence_of(:extracurricular_activities) }
    it { is_expected.to validate_presence_of(:health_coverage) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:branch) }
    it { is_expected.to have_many(:supervisors).dependent(nil) }
  end

  describe 'constants' do
    it 'has valid genders' do
      expect(Student::GENDERS).to eq({
        male: 0,
        female: 1
      }.with_indifferent_access)

      expect(Student::GENDERS).to be_frozen
    end

    it 'has valid statuses' do
      expect(Student::STATUSES).to eq({
        active: 0,
        withdrawn: 1
      }.with_indifferent_access)

      expect(Student::STATUSES).to be_frozen
    end
  end

  describe 'enums' do
    let(:student) { build(:student) }

    it {
      expect(student).to define_enum_for(:gender).with_values(Student::GENDERS)
      expect(student).to define_enum_for(:status).with_values(Student::STATUSES)
    }
  end
end
