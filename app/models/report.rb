# frozen_string_literal: true

class Report < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, :quicksight_embed_src, :quicksight_dashboard_id, presence: true

  belongs_to :organization
end
