# frozen_string_literal: true

class AllyBranch < ApplicationRecord
  belongs_to :ally
  belongs_to :branch
end
