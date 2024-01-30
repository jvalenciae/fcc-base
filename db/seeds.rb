# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 5.times do
#   Organization.create!(
#     name: Faker::Company.name,
#     country: 'CO',
#     report_id: '123456'
#   )
# end

# organizations = Organization.all
# 20.times do
#   Branch.create!(
#     name: Faker::Name.name,
#     country: 'CO',
#     department: 'ATL',
#     city: CS.states(:CO).keys.flat_map { |state| CS.cities(state, :CO) }.sample,
#     address: Faker::Address.full_address,
#     phone_number: Faker::Number.number(digits: 10),
#     organization: organizations.sample
#   )
# end

user = FactoryBot.create(:user, email: 'super_admin@gmail.com', password: 'Password123!', role: 'operative_director',
                                organization: nil)
user.save!

user = FactoryBot.create(:user, email: 'jemiliov1999@gmail.com', password: 'Password123!', role: 'operative_director',
  organization: nil)
user.save!

# user = FactoryBot.create(:user, email: 'admin@gmail.com', password: 'Password123!', role: 'operations_coordinator',
#                                 organization: Organization.first)
# user.branches << Organization.first.branches
# user.save!

# user = FactoryBot.create(:user, email: 'admin2@gmail.com', password: 'Password123!', role: 'operations_coordinator',
#                                 organization: Organization.second)
# user.save!

# user = FactoryBot.create(:user, email: 'admin3@gmail.com', password: 'Password123!', role: 'operations_coordinator',
#                                 organization: Organization.third)
# user.save!

# user = FactoryBot.create(:user, email: 'admin4@gmail.com', password: 'Password123!', role: 'operations_coordinator',
#                                 organization: Organization.fourth)
# user.save!

# user = FactoryBot.create(:user, email: 'javier@gmail.com', password: 'Password123!', role: 'trainer',
#                                 organization: Organization.first)
# user.branches << Organization.first.branches.first
# user.save!

# branches = Branch.all
# 20.times do
#   Ally.create!(
#     name: Faker::Company.name,
#     organization: organizations.sample,
#     branches: branches.sample(2)
#   )
# end

# 40.times do
#   Group.create!(
#     category: rand(0..3),
#     name: Faker::Name.name,
#     branch_id: branches.sample.id
#   )
# end

# groups = Group.all
# 400.times do
#   group = groups.sample
#   statuses = Student::STATUSES.keys
#   # hcs = Student::HEALTH_COVERAGES.keys
#   FactoryBot.create(
#     :student, group: group, branch: group.branch, status: statuses.sample, health_coverage: 1,
#               beneficiary_of_another_foundation: [true, false].sample, displaced: [true, false].sample,
#               lives_with_reinserted_familiar: [true, false].sample
#   )
# end

# students = Student.all
# 400.times do
#   FactoryBot.create(:supervisor, student: students.sample)
# end

# 10.times do
#   FactoryBot.create(:report, organization: organizations.sample)
# end

# organizations = Organization.all
# 10.times do
#   FactoryBot.create(:survey, organization: organizations.sample)
# end
