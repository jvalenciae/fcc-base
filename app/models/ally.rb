# frozen_string_literal: true

class Ally < ApplicationRecord
  validates :name, presence: true

  belongs_to :organization

  has_many :ally_branches, dependent: nil
  has_many :branches, through: :ally_branches
end
