# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupAttendance do
  subject(:group_attendance) { create(:group_attendance) }

  describe 'validations' do
    it 'validates presence' do
      expect(group_attendance).to validate_presence_of(:date)
    end
  end

  describe 'associations' do
    it 'validates associations' do
      expect(group_attendance).to belong_to(:group)
      expect(group_attendance).to have_many(:student_attendances).dependent(:delete_all)
    end
  end

  describe 'scopes' do
    # rubocop:disable RSpec/IndexedLet
    let(:branch1) { create(:branch) }
    let(:branch2) { create(:branch) }
    let(:group1) { create(:group, branch: branch1) }
    let(:group2) { create(:group, branch: branch2) }
    # rubocop:enable RSpec/IndexedLet

    before do
      create(:group_attendance, date: Time.zone.yesterday, group: group1)
      create(:group_attendance, date: Time.zone.today, group: group1)
      create(:group_attendance, date: Time.zone.tomorrow, group: group2)
    end

    describe '.by_branch_ids' do
      it 'filters group attendances by branch ids' do
        results = described_class.by_branch_ids([branch1.id])
        expect(results.count).to eq(2)
        expect(results.pluck(:group_id).uniq).to eq([group1.id])
      end

      it 'returns all group attendances when branch_ids is blank' do
        results = described_class.by_branch_ids([])
        expect(results.count).to eq(3)
      end
    end

    describe '.by_group_ids' do
      it 'filters group attendances by group ids' do
        results = described_class.by_group_ids([group2.id])
        expect(results.count).to eq(1)
        expect(results.first.group).to eq(group2)
      end

      it 'returns all group attendances when group_ids is blank' do
        results = described_class.by_group_ids([])
        expect(results.count).to eq(3)
      end
    end

    describe '.by_date' do
      it 'filters group attendances by date' do
        date = Time.zone.today
        results = described_class.by_date(date)
        expect(results.count).to eq(1)
        expect(results.first.date).to eq(date)
      end

      it 'returns all group attendances when date is blank' do
        results = described_class.by_date(nil)
        expect(results.count).to eq(3)
      end
    end
  end
end
