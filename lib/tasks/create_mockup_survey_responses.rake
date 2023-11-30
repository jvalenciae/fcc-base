# frozen_string_literal: true

require 'csv'

task create_hplv_survey_responses: :environment do
  survey = Survey.find_or_create_by(name: 'HPLV', description: 'HPLV Survey', form_id: 'form_id',
                                    organization_id: Organization.first.id)

  students = Student.all

  students.each_with_index do |student, index|
    puts "INDEX: #{index}"
    data = {
      event_id: "response_id_#{student.id}",
      form_response: {
        variables: [
          {
            key: 'assertiveness',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'assertiveness_count',
            type: 'number',
            number: 3
          },
          {
            key: 'autonomy',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'autonomy_count',
            type: 'number',
            number: 3
          },
          {
            key: 'autoreflexion',
            type: 'number',
            number: rand(0..15)
          },
          {
            key: 'autoreflexion_count',
            type: 'number',
            number: 5
          },
          {
            key: 'conflict_resolution',
            type: 'number',
            number: rand(0..15)
          },
          {
            key: 'conflict_resolution_count',
            type: 'number',
            number: 5
          },
          {
            key: 'control_emotions',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'control_emotions_count',
            type: 'number',
            number: 3
          },
          {
            key: 'cooperation',
            type: 'number',
            number: rand(0..12)
          },
          {
            key: 'cooperation_count',
            type: 'number',
            number: 4
          },
          {
            key: 'decisionmaking',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'decisionmaking_count',
            type: 'number',
            number: 3
          },
          {
            key: 'empathy',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'empathy_count',
            type: 'number',
            number: 3
          },
          {
            key: 'expression',
            type: 'number',
            number: rand(0..12)
          },
          {
            key: 'expression_count',
            type: 'number',
            number: 4
          },
          {
            key: 'flexible_thinking',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'flexible_thinking_count',
            type: 'number',
            number: 3
          },
          {
            key: 'knowledge_himself',
            type: 'number',
            number: rand(0..12)
          },
          {
            key: 'knowledge_himself_count',
            type: 'number',
            number: 4
          },
          {
            key: 'relationships',
            type: 'number',
            number: rand(0..12)
          },
          {
            key: 'relationships_count',
            type: 'number',
            number: 4
          },
          {
            key: 'respect',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'respect_count',
            type: 'number',
            number: 3
          },
          {
            key: 'score',
            type: 'number',
            number: rand(0..12)
          },
          {
            key: 'stress_management',
            type: 'number',
            number: rand(0..9)
          },
          {
            key: 'stress_management_count',
            type: 'number',
            number: 3
          }
        ],
        answers: [
          {
            type: 'date',
            date: '2023-01-01'
          },
          {
            choice: {
              label: 'kind_of_measurement'
            }
          }
        ],
        hidden: {
          survey_id: survey.id,
          student_id: student.id
        }
      }
    }

    response_id = "response_id_#{student.id}"
    date = '2023-01-01'
    kind_of_measurement = 'Ingreso'
    scores = data[:form_response][:variables]
    survey_id = survey.id
    student_id = student.id

    survey_response = SurveyResponse.find_or_initialize_by(
      date: date,
      kind_of_measurement: kind_of_measurement,
      survey_id: survey_id,
      student_id: student_id
    )

    survey_response.response_id = response_id
    survey_response.json_response = data
    survey_response.scores = scores

    survey_response.save!
  end
end
