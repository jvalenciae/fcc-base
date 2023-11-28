# frozen_string_literal: true

class Survey < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, :description, :form_id, presence: true

  belongs_to :organization
  has_many :survey_responses, dependent: nil
end
