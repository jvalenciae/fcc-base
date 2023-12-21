# frozen_string_literal: true

require 'csv'

class StudentsExportService < ApplicationService
  attr_accessor :students

  def initialize(students)
    @students = students
  end

  def call
    CSV.generate do |csv|
      csv << build_headers

      students.each do |student|
        csv << build_row(student)
      end
    end
  end

  private

  def build_headers
    student_header = Student.new.attributes.keys
    supervisor_header = Supervisor.new.attributes.keys
    sh1 = supervisor_header.map { |sh| "supervisor1_#{sh}" }
    sh2 = supervisor_header.map { |sh| "supervisor2_#{sh}" }
    (student_header + sh1 + sh2)
  end

  def build_row(record)
    student_attributes = record.attributes.values
    supervisors_attr = []
    supervisors_attr += record.supervisors.first&.attributes&.values || Array.new(Supervisor.new.attributes.size)
    supervisors_attr += record.supervisors.second&.attributes&.values || Array.new(Supervisor.new.attributes.size)
    (student_attributes + supervisors_attr)
  end
end
