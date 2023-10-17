# frozen_string_literal: true

task create_mockup_data: :environment do
  booleans = [true, false]
  countries = %w[CO US BR AR MX]

  # Create Organizations
  puts 'Creating Organizations'
  5.times do |index|
    Organization.create!(
      name: Faker::Company.name,
      country: countries[index],
      report_id: '123456'
    )
  end

  organizations = Organization.all

  organizations.each do |organization|
    country = organization.country
    # Create Branches
    puts 'Creating Branches'
    10.times do
      state = CS.states(country.to_sym).keys.sample.to_s
      city = CS.cities(state.to_sym, country.to_sym).sample
      Branch.create!(
        name: Faker::Name.name,
        country: country,
        department: state,
        city: city,
        address: Faker::Address.full_address,
        phone_number: Faker::Number.number(digits: 10),
        organization: organization
      )
    end

    branches = Branch.by_organization_ids(organization.id)
    # Create Allies
    puts 'Creating Allies'
    5.times do
      Ally.create!(
        name: Faker::Company.name,
        organization: organization,
        branches: branches.sample(rand(1..5))
      )
    end

    branches.each do |branch|
      city = branch.city
      # Create Groups
      puts 'Creating Groups'
      4.times do
        Group.create!(
          category: rand(0..3),
          name: Faker::Name.name,
          branch: branch
        )
      end

      groups = Group.by_branch_ids(branch.id)
      # Create Students
      puts 'Creating Students'
      groups.each do |group|
        rand(20..30).times do
          statuses = Student::STATUSES.keys
          FactoryBot.create(
            :student, group: group, branch: branch, status: statuses.sample, health_coverage: 1,
                      beneficiary_of_another_foundation: booleans.sample, displaced: booleans.sample,
                      lives_with_reinserted_familiar: booleans.sample, birthplace: country,
                      country: country, city: city
          )
        end

        students = Student.by_group_ids(group.id)
        # Create Attedances
        puts 'Creating Attendances'
        dates = %w[
          03-07-2023 05-07-2023 10-07-2023 12-07-2023 17-07-2023 19-07-2023 24-07-2023 26-07-2023
          07-08-2023 09-08-2023 14-08-2023 16-08-2023 21-08-2023 23-08-2023 28-08-2023 30-08-2023
          04-09-2023 06-09-2023 11-09-2023 13-09-2023 18-09-2023 20-09-2023 25-09-2023 27-09-2023
        ]
        dates.each do |date|
          ga = GroupAttendance.create(date: date, group: group)
          students.each do |student|
            StudentAttendance.create(student: student, present: booleans.sample, group_attendance: ga)
          end
        end
      end
    end
  end
end
