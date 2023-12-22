# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:form_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:survey_responses).dependent(nil) }
  end

  describe 'scopes' do
    let!(:default_survey) { create(:survey, default: true, name: 'Default Survey') }
    let!(:ad_hoc_survey) { create(:survey, default: false, name: 'Ad Hoc Survey') }

    describe '.default' do
      it 'returns default surveys' do
        expect(described_class.default).to eq([default_survey])
      end
    end

    describe '.hplv' do
      it 'returns HPLV surveys' do
        hplv_survey = create(:survey, default: true, name: 'Habilidades para la Vida Survey')
        expect(described_class.hplv).to eq([hplv_survey])
      end
    end

    describe '.field_behavior' do
      it 'returns field behavior surveys' do
        field_behavior_survey = create(:survey, default: true, name: 'Comportamiento en la Cancha Survey')
        expect(described_class.field_behavior).to eq([field_behavior_survey])
      end
    end

    describe '.conceptualization' do
      it 'returns conceptualization surveys' do
        conceptualization_survey = create(:survey, default: true, name: 'Conceptualizacion Survey')
        expect(described_class.conceptualization).to eq([conceptualization_survey])
      end
    end

    describe '.tech_test' do
      it 'returns tech_test surveys' do
        tech_test_survey = create(:survey, default: true, name: 'tecnico Survey')
        expect(described_class.tech_test).to eq([tech_test_survey])
      end
    end

    describe '.soccer_for_peace' do
      it 'returns soccer_for_peace surveys' do
        soccer_for_peace_survey = create(:survey, default: true, name: 'futbol por la paz Survey')
        expect(described_class.soccer_for_peace).to eq([soccer_for_peace_survey])
      end
    end

    describe '.parent_school' do
      it 'returns parent_school surveys' do
        parent_school_survey = create(:survey, default: true, name: 'escuela de padres Survey')
        expect(described_class.parent_school).to eq([parent_school_survey])
      end
    end

    describe '.school_behavior' do
      it 'returns school_behavior surveys' do
        school_behavior_survey = create(:survey, default: true, name: 'Comportamiento escolar Survey')
        expect(described_class.school_behavior).to eq([school_behavior_survey])
      end
    end

    describe '.soccer_schools' do
      it 'returns soccer_schools surveys' do
        soccer_schools_survey = create(:survey, default: true, name: 'escuelas de futbol Survey')
        expect(described_class.soccer_schools).to eq([soccer_schools_survey])
      end
    end

    describe '.ad_hoc' do
      it 'returns ad hoc surveys' do
        expect(described_class.ad_hoc).to eq([ad_hoc_survey])
      end
    end
  end
end
