# frozen_string_literal: true

class StudentsFilterService < ApplicationService
  attr_reader :params, :students

  def initialize(students, params)
    @students = students
    @params = params
  end

  def call
    apply_filters(students)
  end

  private

  # rubocop:disable Metrics/AbcSize
  def apply_filters(students)
    students = students.by_branch_ids(params[:branch_ids])
    students = students.by_categories(params[:categories])
    students = students.by_group_ids(params[:group_ids])
    students = students.by_statuses(params[:statuses])
    students = students.by_tshirt_sizes(params[:tshirt_sizes])
    students = students.by_shorts_sizes(params[:shorts_sizes])
    students = students.by_socks_sizes(params[:socks_sizes])
    students = students.by_shoe_sizes(params[:shoe_sizes])
    students = students.by_health_coverages(params[:health_coverages])
    students = students.by_beneficiary_of_another_foundation(params[:beneficiary_of_another_foundation])
    students = students.by_displaced(params[:displaced])
    students.by_lives_with_reinserted_familiar(params[:lives_with_reinserted_familiar])
  end
  # rubocop:enable Metrics/AbcSize
end
