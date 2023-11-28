# frozen_string_literal: true

FactoryBot.define do
  factory :survey_response do
    response_id { Faker::Alphanumeric.alpha(number: 20) }
    date { Time.zone.today }
    json_response do
      {
        event_id: '01HEA1B2BYPVY38N6SRYYQSSSJ',
        event_type: 'form_response',
        form_response: {
          hidden: {
            student_id: 'e777cdec-a392-4f9a-8aa6-a9da31274573',
            survey_id: 'fde486f1-c89e-47e1-a691-3163e32f28cd'
          },
          answers: [
            {
              type: 'date',
              date: '2023-11-03'
            }
          ]
        }
      }
    end
    kind_of_measurement { 'Ingreso' }
    scores do
      [
        {
          key: 'assertiveness',
          type: 'number',
          number: 8
        },
        {
          key: 'autonomy',
          type: 'number',
          number: 5
        },
        {
          key: 'autoreflexion',
          type: 'number',
          number: 7
        },
        {
          key: 'conflict_resolution',
          type: 'number',
          number: 6
        },
        {
          key: 'control_emotions',
          type: 'number',
          number: 8
        },
        {
          key: 'cooperation',
          type: 'number',
          number: 9
        },
        {
          key: 'decisionmaking',
          type: 'number',
          number: 6
        },
        {
          key: 'empathy',
          type: 'number',
          number: 5
        },
        {
          key: 'expression',
          type: 'number',
          number: 10
        },
        {
          key: 'flexible_thinking',
          type: 'number',
          number: 6
        },
        {
          key: 'knowledge_himself',
          type: 'number',
          number: 9
        },
        {
          key: 'relationships',
          type: 'number',
          number: 9
        },
        {
          key: 'respect',
          type: 'number',
          number: 5
        },
        {
          key: 'score',
          type: 'number',
          number: 0
        },
        {
          key: 'stress_management',
          type: 'number',
          number: 5
        }
      ]
    end

    survey
    student
  end
end
