# frozen_string_literal: true

class Branch < ApplicationRecord
  validates :name, :country, :department, :city, :address, :phone_number, presence: true

  validate :validate_allies_belongs_to_organization

  belongs_to :organization

  has_many :user_branches, dependent: :destroy
  has_many :users, through: :user_branches

  has_many :ally_branches, dependent: :destroy
  has_many :allies, through: :ally_branches

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

  private

  def validate_allies_belongs_to_organization
    return if allies.blank?

    return if allies.all? { |ally| ally.organization == organization }

    errors.add(:allies, "Some allies don't belong to the branch's organization")
  end
end
