# frozen_string_literal: true

class Group < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :category, :name, presence: true
  validates :name, uniqueness: {
    scope: %i[category branch_id]
  }

  belongs_to :branch

  has_many :students, dependent: nil
  has_many :group_attendances, dependent: nil

  CATEGORIES = {
    creators: 0,
    explorers: 1,
    builders: 2,
    promoters: 3
  }.with_indifferent_access.freeze

  enum category: CATEGORIES

  scope :by_branch_ids, lambda { |branch_ids|
    return all if branch_ids.blank?

    where(branch_id: branch_ids)
  }

  scope :by_categories, lambda { |categories|
    return all if categories.blank?

    where(category: categories)
  }
end
