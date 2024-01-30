# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_inclusion_of(:status).in_array(%w[pending completed]) }
  end

  describe 'scopes' do
    let!(:pending_task) { create(:task, status: 'pending') }
    let!(:completed_task) { create(:task, status: 'completed') }

    it 'returns pending tasks' do
      expect(described_class.pending).to include(pending_task)
      expect(described_class.pending).not_to include(completed_task)
    end

    it 'returns completed tasks' do
      expect(described_class.completed).to include(completed_task)
      expect(described_class.completed).not_to include(pending_task)
    end
  end

  describe '#overdue?' do
    it 'returns true if the task is overdue and pending' do
      overdue_task = create(:task, due_date: 1.day.ago, status: 'pending')
      expect(overdue_task.overdue?).to be true
    end

    it 'returns false if the task is completed' do
      completed_task = create(:task, due_date: 1.day.ago, status: 'completed')
      expect(completed_task.overdue?).to be false
    end

    it 'returns false if the task is pending but not overdue' do
      not_overdue_task = create(:task, due_date: 1.day.from_now, status: 'pending')
      expect(not_overdue_task.overdue?).to be false
    end
  end
end
