# frozen_string_literal: true

class Ally < ApplicationRecord
  self.implicit_order_column = 'created_at'

  validates :name, presence: true

  belongs_to :organization

  has_many :ally_branches, dependent: nil
  has_many :branches, through: :ally_branches
end
