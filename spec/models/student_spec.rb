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

    describe '#validate_group_belongs_to_branch' do
      it 'is valid when group belongs to the same branch' do
        branch = create(:branch)
        group = create(:group, branch: branch)
        student = build(:student, branch: branch, group: group)

        expect(student).to be_valid
      end

      it 'is invalid when group does not belong to the same branch' do
        branch1 = create(:branch)
        branch2 = create(:branch)
        group = create(:group, branch: branch1)
        student = build(:student, branch: branch2, group: group)

        expect(student).to be_invalid
        student.valid?
        expect(student.errors[:group]).to include('Group does not belong to the branch')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:branch) }
    it { is_expected.to have_many(:supervisors).dependent(nil) }
    it { is_expected.to have_many(:student_attendances).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe 'before_create :set_default_status' do
      it 'sets a default status if status is blank' do
        student = create(:student, status: nil)

        expect(student.status).not_to be_nil
      end

      it 'does not change the status if it is present' do
        student = create(:student, status: Student::STATUSES.keys.last)

        expect(student.status).to eq(Student::STATUSES.keys.last)
      end
    end
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
      expect(student).to define_enum_for(:health_coverage).with_values(Student::HEALTH_COVERAGES)
    }
  end

  describe 'scopes' do
    # rubocop:disable RSpec:IndexedLet
    let!(:branch1) { create(:branch) }
    let!(:branch2) { create(:branch) }
    let!(:group1) { create(:group, branch: branch1, category: Group::CATEGORIES.keys.first) }
    let!(:group2) { create(:group, branch: branch2, category: Group::CATEGORIES.keys.last) }
    let!(:student1) do
      create(:student, branch: branch1, group: group1, tshirt_size: 1, shorts_size: 1, socks_size: 1, shoe_size: 1,
                       health_coverage: 'eps', beneficiary_of_another_foundation: true, status: 'active',
                       lives_with_reinserted_familiar: true, displaced: true)
    end
    let!(:student2) do
      create(:student, branch: branch2, group: group2, tshirt_size: 2, shorts_size: 2, socks_size: 2, shoe_size: 2,
                       health_coverage: 'sisben', beneficiary_of_another_foundation: false, status: 'withdrawn',
                       lives_with_reinserted_familiar: false, displaced: false)
    end
    # rubocop:enable RSpec:IndexedLet

    # rubocop:disable RSpec:MultipleMemoizedHelpers
    describe '.by_branch_ids' do
      it 'filters students by branch_ids' do
        result = described_class.by_branch_ids([branch1.id])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_categories' do
      it 'filters students by categories' do
        result = described_class.by_categories([group1.category])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_group_ids' do
      it 'filters students by group_ids' do
        result = described_class.by_group_ids([group1.id])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_statuses' do
      it 'filters students by statuses' do
        result = described_class.by_statuses([described_class::STATUSES.keys.first])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_tshirt_sizes' do
      it 'filters students by tshirt_sizes' do
        result = described_class.by_tshirt_sizes([1])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_shorts_sizes' do
      it 'filters students by shorts_sizes' do
        result = described_class.by_shorts_sizes([2])

        expect(result).to contain_exactly(student2)
      end
    end

    describe '.by_socks_sizes' do
      it 'filters students by socks_sizes' do
        result = described_class.by_socks_sizes([1])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_shoe_sizes' do
      it 'filters students by shoe_sizes' do
        result = described_class.by_shoe_sizes([2])

        expect(result).to contain_exactly(student2)
      end
    end

    describe '.by_health_coverages' do
      it 'filters students by health_coverages' do
        result = described_class.by_health_coverages(['eps'])

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_beneficiary_of_another_foundation' do
      it 'filters students by beneficiary_of_another_foundation' do
        result = described_class.by_beneficiary_of_another_foundation(false)

        expect(result).to contain_exactly(student2)
      end
    end

    describe '.by_displaced' do
      it 'filters students by displaced' do
        result = described_class.by_displaced(true)

        expect(result).to contain_exactly(student1)
      end
    end

    describe '.by_lives_with_reinserted_familiar' do
      it 'filters students by lives_with_reinserted_familiar' do
        result = described_class.by_lives_with_reinserted_familiar(false)

        expect(result).to contain_exactly(student2)
      end
    end
    # rubocop:enable RSpec:MultipleMemoizedHelpers
  end
end
