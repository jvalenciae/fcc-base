# frozen_string_literal: true

class Survey < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, :description, :form_id, presence: true

  belongs_to :organization
  has_many :survey_responses, dependent: nil

  scope :default, -> { where(default: true) }
  scope :hplv, -> { default.where('name ILIKE ?', '%habilidades para la vida%') }
  scope :field_behavior, -> { default.where('name ILIKE ?', '%comportamiento en la cancha%') }
  scope :conceptualization, -> { default.where('unaccent(name) ILIKE unaccent(?)', '%conceptualizacion%') }
  scope :tech_test, -> { default.where('unaccent(name) ILIKE unaccent(?)', '%tecnico%') }
  scope :soccer_for_peace, -> { default.where('name ILIKE ?', '%por la paz%') }
  scope :parent_school, -> { default.where('name ILIKE ?', '%escuela de padres%') }
  scope :school_behavior, -> { default.where('name ILIKE ?', '%comportamiento escolar%') }
  scope :soccer_schools, -> { default.where('unaccent(name) ILIKE unaccent(?)', '%escuelas de futbol%') }
  scope :ad_hoc, -> { where(default: false) }
end
