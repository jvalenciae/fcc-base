# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validates :status, inclusion: { in: %w[pending completed] }

  scope :pending, -> { where(status: 'pending') }
  scope :completed, -> { where(status: 'completed') }

  def overdue?
    due_date < Time.zone.now && status == 'pending'
  end
end
