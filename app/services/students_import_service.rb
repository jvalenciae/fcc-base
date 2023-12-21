# frozen_string_literal: true

require 'csv'
require 'open-uri'

class StudentsImportService < ApplicationService
  attr_accessor :file_url, :user

  def initialize(file_url = './tmp/children.csv', user = nil)
    @file_url = file_url
    @user = user
  end

  def call
    csv_data, success_entries, failed_entries = import_students_and_log_results
    csv_name = "students_import_#{Time.zone.today.strftime('%d-%m-%Y')}.csv"
    attachments = build_attachments(csv_data, csv_name)

    ImportMailer.students(user, success_entries + failed_entries, success_entries, failed_entries, csv_name,
                          attachments)
  end

  private

  def import_students_and_log_results
    options = { headers: true, col_sep: ',' }
    success_entries = 0
    failed_entries = 0
    csv_data = CSV.generate do |csv|
      csv << build_headers
      CSV.parse(URI.parse(file_url).read, **options) do |row|
        csv, success_entries, failed_entries = save_or_log_student(csv, row, success_entries, failed_entries)
      end
    end
    [csv_data, success_entries, failed_entries]
  end

  def save_or_log_student(csv, row, success_entries, failed_entries)
    student_hash = row.headers.zip(row.fields).to_h
    student = Student.find_or_initialize_by(student_hash)
    if student.save
      success_entries += 1
    else
      failed_entries += 1
      csv << build_row(student)
    end
    [csv, success_entries, failed_entries]
  end

  def build_headers
    Student.new.attributes.keys + %w[errors]
  end

  def build_row(record)
    record_attributes = record.attributes.values
    errors = record.errors.full_messages.to_sentence
    (record_attributes + [errors])
  end

  def build_attachments(csv_data, csv_name)
    [
      {
        data: csv_data,
        type: 'application/csv',
        name: csv_name,
        content_id: 'export_file'
      }
    ]
  end
end
