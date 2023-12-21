# frozen_string_literal: true

require 'csv'

task tables_to_csv: :environment do
  # Organizations CSV
  CSV.open('./tmp/export_data/organizations.csv', 'wb') do |csv|
    csv << Organization.new.attributes.keys

    organizations = Organization.all
    organizations.each do |organization|
      csv << organization.attributes.values
    end
  end

  # Branches CSV
  CSV.open('./tmp/export_data/branches.csv', 'wb') do |csv|
    csv << Branch.new.attributes.keys

    branches = Branch.all
    branches.each do |branch|
      csv << branch.attributes.values
    end
  end

  # Allies CSV
  CSV.open('./tmp/export_data/allies.csv', 'wb') do |csv|
    csv << Ally.new.attributes.keys

    allies = Ally.all
    allies.each do |ally|
      csv << ally.attributes.values
    end
  end

  # Groups CSV
  CSV.open('./tmp/export_data/groups.csv', 'wb') do |csv|
    csv << Group.new.attributes.keys

    groups = Group.all
    groups.each do |group|
      csv << group.attributes.values
    end
  end

  # Students CSV
  CSV.open('./tmp/export_data/students.csv', 'wb') do |csv|
    csv << Student.new.attributes.keys

    students = Student.all
    students.each do |student|
      csv << student.attributes.values
    end
  end

  # GroupAttendance CSV
  CSV.open('./tmp/export_data/group_attendances.csv', 'wb') do |csv|
    csv << GroupAttendance.new.attributes.keys

    group_attendances = GroupAttendance.all
    group_attendances.each do |group_attendance|
      csv << group_attendance.attributes.values
    end
  end

  # StudentAttendance CSV
  CSV.open('./tmp/export_data/student_attendances.csv', 'wb') do |csv|
    csv << StudentAttendance.new.attributes.keys

    student_attendances = StudentAttendance.all
    student_attendances.each do |student_attendance|
      csv << student_attendance.attributes.values
    end
  end
end
