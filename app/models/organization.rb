# frozen_string_literal: true

class Organization < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, :country, :report_id, presence: true

  has_one_attached :logo

  has_many :branches, dependent: nil
  has_many :users, dependent: nil
  has_many :allies, dependent: nil
  has_many :reports, dependent: nil

  include PgSearch::Model
  pg_search_scope :search_by_q,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }, ignoring: :accents
end
