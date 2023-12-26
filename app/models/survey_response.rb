# frozen_string_literal: true

class SurveyResponse < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :response_id, :json_response, :date, presence: true
  validates :response_id, uniqueness: true, allow_nil: false

  belongs_to :survey
  belongs_to :branch, optional: true
  belongs_to :student, optional: true

  has_many :single_response_inputs, dependent: :destroy

  scope :by_survey_ids, lambda { |survey_ids|
    return all if survey_ids.blank?

    where(survey_id: survey_ids)
  }

  scope :by_branch_ids, lambda { |branch_ids|
    return all if branch_ids.blank?

    where(branch_id: branch_ids)
  }

  scope :by_group_ids, lambda { |group_ids|
    return all if group_ids.blank?

    joins(:student).where(student: { group_id: group_ids })
  }

  scope :by_categories, lambda { |categories|
    return all if categories.blank?
    return all unless categories.is_a?(Array)

    joins(student: [:group]).where(group: { category: categories.map { |cat| Group.categories[cat] } })
  }

  scope :by_gender, lambda { |gender|
    return all if gender.blank?

    joins(:student).where(student: { gender: gender })
  }

  scope :by_kind_of_measurement, lambda { |kind_of_measurement|
    return all if kind_of_measurement.blank?

    where(kind_of_measurement: kind_of_measurement)
  }

  scope :by_years, lambda { |years|
    return all if years.blank?

    where('EXTRACT(YEAR FROM date) IN (?)', years)
  }
end
