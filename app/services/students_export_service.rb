# frozen_string_literal: true

require 'csv'

class StudentsExportService < ApplicationService
  attr_accessor :students

  def initialize(students)
    @students = students
  end

  def call
    CSV.generate do |csv|
      csv << Student.take.attributes.keys

      students.each do |student|
        csv << student.attributes.values
      end
    end
  end
end
