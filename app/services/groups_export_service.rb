# frozen_string_literal: true

require 'csv'

class GroupsExportService < ApplicationService
  attr_accessor :groups

  def initialize(groups)
    @groups = groups
  end

  def call
    CSV.generate do |csv|
      csv << Group.new.attributes.keys

      groups.each do |group|
        csv << group.attributes.values
      end
    end
  end
end
