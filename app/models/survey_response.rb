# frozen_string_literal: true

class SurveyResponse < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :response_id, :json_response, :date, :kind_of_measurement, :scores, presence: true
  validates :response_id, uniqueness: true, allow_nil: false

  belongs_to :survey
  belongs_to :branch, optional: true
  belongs_to :student, optional: true
end
