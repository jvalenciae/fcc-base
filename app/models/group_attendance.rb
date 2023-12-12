# frozen_string_literal: true

class GroupAttendance < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :date, presence: true

  belongs_to :group
  has_many :student_attendances, dependent: :delete_all

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  associated_against: {
                    group: [:display_name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents

  scope :by_branch_ids, lambda { |branch_ids|
    return all if branch_ids.blank?

    joins(:group).where(group: { branch_id: branch_ids })
  }

  scope :by_group_ids, lambda { |group_ids|
    return all if group_ids.blank?

    where(group_id: group_ids)
  }

  scope :by_date, lambda { |date|
    return all if date.blank?

    where(date: date)
  }
end
