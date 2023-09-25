# frozen_string_literal: true

class Supervisor < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :id_number, :name, :email, :birthdate, :phone_number, :profession, :relationship, presence: true

  belongs_to :student

  RELATIONSHIPS = {
    father: 0,
    mother: 1,
    sibling: 2,
    cousin: 3,
    uncle: 4,
    aunt: 5
  }.with_indifferent_access.freeze

  enum relationship: RELATIONSHIPS
end
