# frozen_string_literal: true

class StudentsImportJob
  include Sidekiq::Job

  def perform(file_url)
    StudentsImportService.call(file_url)
  end
end
