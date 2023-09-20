# frozen_string_literal: true

require 'csv'

class GroupsExportService < ApplicationService
  attr_accessor :groups

  def initialize(groups)
    @groups = groups
  end

  def call
    CSV.generate do |csv|
      csv << %w[ID Category BranchID BranchName]

      groups.each do |group|
        csv << [group.id, group.category, group.branch.id, group.branch.name]
      end
    end
  end
end
