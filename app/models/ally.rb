# frozen_string_literal: true

class Ally < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, presence: true

  belongs_to :organization

  has_many :ally_branches, dependent: nil
  has_many :branches, through: :ally_branches

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents

  scope :by_organization_ids, lambda { |organization_ids|
    return all if organization_ids.blank?

    where(organization_id: organization_ids)
  }
end
