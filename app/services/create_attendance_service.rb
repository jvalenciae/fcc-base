# frozen_string_literal: true

class CreateAttendanceService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    group_attendance = if params[:id].present?
                         ga = GroupAttendance.find(params[:id])
                         ga.date = params[:date]
                         ga
                       else
                         GroupAttendance.find_or_initialize_by(date: params[:date], group_id: params[:group_id])
                       end

    attendances = params[:attendances]
    attendances.map! do |att|
      StudentAttendance.new(student_id: att[:student_id], present: att[:present])
    end

    [group_attendance, attendances]
  end
end
