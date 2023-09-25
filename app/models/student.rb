# frozen_string_literal: true

class Student < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :id_number, :name, :birthplace, :birthdate, :gender, :tshirt_size, :shorts_size, :socks_size, :shoe_size,
            :favourite_colour, :favourite_food, :favourite_sport, :favourite_place, :feeling_when_playing_soccer, :city,
            :country, :neighborhood, :address, :school, :extracurricular_activities, :health_coverage, presence: true

  belongs_to :group
  belongs_to :branch
  has_many :supervisors, dependent: nil

  GENDERS = {
    male: 0,
    female: 1
  }.with_indifferent_access.freeze

  enum gender: GENDERS

  STATUSES = {
    active: 0,
    withdrawn: 1
  }.with_indifferent_access.freeze

  enum status: STATUSES
end
