# frozen_string_literal: true

class OrganizationBranch < ApplicationRecord
  belongs_to :organization
  belongs_to :branch
end
