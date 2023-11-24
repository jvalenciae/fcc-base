# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsExportService do
  # rubocop:disable RSpec/IndexedLet
  let(:student1) { create(:student, supervisors: build_list(:supervisor, 1)) }
  let(:student2) { create(:student, supervisors: build_list(:supervisor, 2)) }
  # rubocop:enable RSpec/IndexedLet

  let(:students) { [student1, student2] }

  describe '#call' do
    it 'generates a CSV with students information' do
      csv_result = described_class.call(students)

      expect(csv_result).to include(Student.take.attributes.keys.join(','))
      expect(csv_result).to include(student1.attributes.values.join(','))
      expect(csv_result).to include(student2.attributes.values.join(','))
      expect(csv_result).to include(student1.supervisors.first.attributes.values.join(','))
      expect(csv_result).to include(student2.supervisors.first.attributes.values.join(','))
      expect(csv_result).to include(student2.supervisors.second.attributes.values.join(','))
    end
  end
end
