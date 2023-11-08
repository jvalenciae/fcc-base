# frozen_string_literal: true

require 'csv'

class StudentsImportService < ApplicationService
  attr_accessor :file_url

  def initialize(file_url = './tmp/children.csv')
    @file_url = file_url
  end

  def call
    options = { headers: true, col_sep: ',' }
    CSV.parse(URI.parse(file_url).read, **options) do |row|
      student_hash = row.headers.zip(row.fields).to_h
      Student.find_or_create_by!(student_hash)
    end
  end
end
