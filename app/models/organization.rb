# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, :country, :report_id, presence: true

  has_one_attached :logo

  has_many :organization_branches, dependent: :destroy
  has_many :branches, through: :organization_branches

  has_many :user_organizations, dependent: :destroy
  has_many :users, through: :user_organizations

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents
end
