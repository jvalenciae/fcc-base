# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SurveyResponse do
  subject { create(:survey_response) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:response_id) }
    it { is_expected.to validate_presence_of(:json_response) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_uniqueness_of(:response_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:survey) }
    it { is_expected.to belong_to(:branch).optional(true) }
    it { is_expected.to belong_to(:student).optional(true) }
    it { is_expected.to have_many(:single_response_inputs).dependent(:destroy) }
  end

  describe 'by_survey_ids' do
    let!(:survey) { create(:survey, default: true, name: 'Default Survey') }
    let!(:survey_response) { create(:survey_response, survey: survey) }

    before do
      create_list(:survey_response, 3)
    end

    describe '.by_survey_ids' do
      it 'returns filtered surveys' do
        result = described_class.by_survey_ids([survey.id])
        expect(result).to eq([survey_response])
      end
    end
  end

  describe '.by_branch_ids' do
    let(:branch) { create(:branch) }
    let(:group) { create(:group, branch: branch) }
    let(:student) { create(:student, group: group) }
    let!(:survey_response) { create(:survey_response, student: student, branch: branch) }

    before do
      create_list(:survey_response, 3)
    end

    it 'returns filtered surveys' do
      result = described_class.by_branch_ids([branch.id])
      expect(result).to eq([survey_response])
    end
  end

  describe '.by_group_ids' do
    let(:group) { create(:group) }
    let(:student) { create(:student, group: group) }
    let!(:survey_response) { create(:survey_response, student: student) }

    before do
      create_list(:survey_response, 3)
    end

    it 'returns filtered surveys' do
      result = described_class.by_group_ids([group.id])
      expect(result).to eq([survey_response])
    end
  end

  describe '.by_categories' do
    let(:group) { create(:group, category: 'builders') }
    let(:student) { create(:student, group: group) }
    let!(:survey_response) { create(:survey_response, student: student) }

    before do
      wrong_group = create(:group, category: 'explorers')
      wrong_student = create(:student, group: wrong_group)
      create_list(:survey_response, 3, student: wrong_student)
    end

    it 'returns filtered surveys' do
      result = described_class.by_categories([group.category])
      expect(result).to eq([survey_response])
    end
  end

  describe '.by_gender' do
    let(:student) { create(:student, gender: 'male') }
    let!(:survey_response) { create(:survey_response, student: student) }

    before do
      wrong_student = create(:student, gender: 'female')
      create_list(:survey_response, 3, student: wrong_student)
    end

    it 'returns filtered surveys' do
      result = described_class.by_gender([student.gender])
      expect(result).to eq([survey_response])
    end
  end

  describe '.by_kind_of_measurement' do
    let!(:survey_response) { create(:survey_response, kind_of_measurement: 'Ingreso') }

    before do
      create_list(:survey_response, 3, kind_of_measurement: 'Salida')
    end

    it 'returns filtered surveys' do
      result = described_class.by_kind_of_measurement([survey_response.kind_of_measurement])
      expect(result).to eq([survey_response])
    end
  end

  describe '.by_years' do
    let!(:survey_response) { create(:survey_response, date: '01-01-1999') }

    before do
      create_list(:survey_response, 3, date: '01-01-2023')
    end

    it 'returns filtered surveys' do
      result = described_class.by_years([1999])
      expect(result).to eq([survey_response])
    end
  end
end
