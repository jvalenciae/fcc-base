# frozen_string_literal: true

require 'csv'

task create_hplv_survey_responses: :environment do
  surveys = [
    'Habilidades para la vida (Participante)',
    'Habilidades para la vida (Acudiente)',
    'Habilidades para la vida (Entrenador)',
    'Fútbol revisión conceptualización (Habilidades cognitivas)',
    'Fútbol revisión conceptualización (Habilidades emocionales)',
    'Fútbol revisión conceptualización (Habilidades sociales)',
    'Fútbol revisión conceptualización (Gestión del cambio)',
    'Fútbol revisión conceptualización (Equidad de género)',
    'Fútbol revisión conceptualización (Cultura de paz)',
    'Fútbol revisión conceptualización (Conciencia ambiental)',
    'Fútbol revisión conceptualización (Liderazgo)',
    'Fútbol revisión conceptualización (Factores protectores)',
    'Fútbol revisión conceptualización (Proyecto de vida)',
    'Fútbol revisión comportamiento (Habilidades cognitivas)',
    'Fútbol revisión comportamiento (Habilidades emocionales)',
    'Fútbol revisión comportamiento (Habilidades sociales)',
    'Fútbol revisión comportamiento (Gestión del cambio)',
    'Fútbol revisión comportamiento (Equidad de género)',
    'Fútbol revisión comportamiento (Cultura de paz)',
    'Fútbol revisión comportamiento (Conciencia ambiental)',
    'Fútbol revisión comportamiento (Liderazgo)',
    'Fútbol revisión comportamiento (Factores protectores)',
    'Fútbol revisión comportamiento (Proyecto de vida)',
    'Test Técnico'
  ]

  keys = [
    'hpv_nino',
    'hpv_adulto',
    'hpv_asesor',
    'frc_respeto',
    'frc_tolerancia',
    'frc_solidaridad',
    'frc_honestidad',
    'frc_trabajo_en_equipo',
    'frc_equidad_de_genero',
    'frc_no_violencia',
    'frc_prevencion_de_la_drogadiccion',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    ''
  ]

  surveys.each do |survey_name|
    survey = Survey.find_or_create_by(name: survey_name, key: 'hpv', form_id: 'form_id',
                                      organization_id: Organization.first.id)
  end
end

task create_hplv_survey_responses: :environment do
  survey = Survey.find_or_create_by(name: 'Habilidades para la vida', key: 'hpv', form_id: 'form_id',
                                    organization_id: Organization.first.id)

  students = Student.all

  students.each_with_index do |student, index|
    puts "INDEX: #{index}"
    data = {
      event_id: "response_id_#{student.id}_2",
      form_response: {
        variables: [
          {
            key: 'assertiveness',
            type: 'number',
            number: rand(2..9)
          },
          {
            key: 'assertiveness_count',
            type: 'number',
            number: 3
          },
          {
            key: 'autonomy',
            type: 'number',
            number: rand(1..9)
          },
          {
            key: 'autonomy_count',
            type: 'number',
            number: 3
          },
          {
            key: 'autoreflexion',
            type: 'number',
            number: rand(2..15)
          },
          {
            key: 'autoreflexion_count',
            type: 'number',
            number: 5
          },
          {
            key: 'conflict_resolution',
            type: 'number',
            number: rand(6..15)
          },
          {
            key: 'conflict_resolution_count',
            type: 'number',
            number: 5
          },
          {
            key: 'control_emotions',
            type: 'number',
            number: rand(6..9)
          },
          {
            key: 'control_emotions_count',
            type: 'number',
            number: 3
          },
          {
            key: 'cooperation',
            type: 'number',
            number: rand(4..12)
          },
          {
            key: 'cooperation_count',
            type: 'number',
            number: 4
          },
          {
            key: 'decisionmaking',
            type: 'number',
            number: rand(3..9)
          },
          {
            key: 'decisionmaking_count',
            type: 'number',
            number: 3
          },
          {
            key: 'empathy',
            type: 'number',
            number: rand(1..9)
          },
          {
            key: 'empathy_count',
            type: 'number',
            number: 3
          },
          {
            key: 'expression',
            type: 'number',
            number: rand(6..12)
          },
          {
            key: 'expression_count',
            type: 'number',
            number: 4
          },
          {
            key: 'flexible_thinking',
            type: 'number',
            number: rand(4..9)
          },
          {
            key: 'flexible_thinking_count',
            type: 'number',
            number: 3
          },
          {
            key: 'knowledge_himself',
            type: 'number',
            number: rand(5..12)
          },
          {
            key: 'knowledge_himself_count',
            type: 'number',
            number: 4
          },
          {
            key: 'relationships',
            type: 'number',
            number: rand(2..12)
          },
          {
            key: 'relationships_count',
            type: 'number',
            number: 4
          },
          {
            key: 'respect',
            type: 'number',
            number: rand(4..9)
          },
          {
            key: 'respect_count',
            type: 'number',
            number: 3
          },
          {
            key: 'score',
            type: 'number',
            number: rand(5..12)
          },
          {
            key: 'stress_management',
            type: 'number',
            number: rand(4..9)
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
            date: '2023-01-02'
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

    response_id = "response_id_#{student.id}_2"
    date = '2023-01-02'
    kind_of_measurement = 'Salida'
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

task create_conceptualization_survey_responses: :environment do
  survey = Survey.find_or_create_by(name: 'Fútbol revision conceptualización (Factores Protectores)',
                                    key: 'frc_', form_id: 'form_id',
                                    organization_id: Organization.first.id)

  students = Student.all

  responses = ['Apropiación nula', 'Apropiación parcial', 'Apropiación parcial', 'Apropiación total',
               'Apropiación total', 'Apropiación total']

  students.each_with_index do |student, index|
    puts "INDEX: #{index}"
    data = {
      event_id: "conceptualization_response_id_#{student.id}_9",
      form_response: {
        variables: [
          {
            key: 'score',
            type: 'number',
            number: 0
          }
        ],
        answers: [
          {
            type: 'date',
            date: '2023-01-01'
          },
          {
            type: 'text',
            text: 'Trainer'
          },
          {
            type: 'text',
            text: 'Answer'
          },
          {
            type: 'choice',
            choice: {
              label: responses.sample
            }
          }
        ],
        hidden: {
          survey_id: survey.id,
          student_id: student.id
        }
      }
    }

    response_id = "conceptualization_response_id_#{student.id}_9"
    date = '2023-01-09'
    kind_of_measurement = 'NA'
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

task create_behavior_survey_responses: :environment do
  # 8adb4f64-5877-49ae-b5de-b5f186c30b25
  surveys = ['Habilidades cognitivas', 'Habilidades emocionales', 'Habilidades sociales', 'Gestión del cambio',
             'Equidad de género', 'Cultura de Paz', 'Conciencia Ambiental', 'Liderazgo', 'Factores Protectores',
             'Proyecto de Vida']

  questions = [
    ['Participa libre y sin presiones en las acciones de juego',
     'Expresa inconformidades e ideas creativas de forma fluida',
     'Sugiere opciones para dar solución a un problema'],
    ['Reconoce sus habilidades y limitaciones sin menospreciarse',
     'Evita hacer daño a los demás o a sí mismo ante las tensiones del entorno',
     'Demuestra tranquilidad ante situaciones tensionantes'],
    ['Trabaja en equipo con las personas que le rodean',
     'Evidencia comprensión de las ideas y/o emociones de las demás personas',
     'Expresa sus ideas y emociones sin hacer daño a otras personas o a sí mismo'],
    ['Analiza y debate con seguridad las situaciones que se presentan en su entorno',
     'Sugiere y/o aplica acciones creativas ante situaciones nuevas o cambiantes',
     'Demuestra facilidad para responder a las situaciones nuevas y cambios del entorno'],
    ['Permite que todos participen en las actividades independientemente de su género',
     'Evita referirse de manera despectiva a las personas de otro género',
     'Evita auto-discriminarse por su género'],
    ['Demuestra conocimiento de estrategias para promover la sana convivencia',
     'Soluciona los problemas evitando agredir a los demás o a sí mismo',
     'Aplica acciones que promueven la sana convivencia'],
    ['Reconoce que el ambiente requiere de sus cuidados',
     'Ejecuta acciones de cuidado del ambiente',
     'Promueve el cuidado del ambiente'],
    ['Demuestra iniciativa en las diferentes acciones individuales o de grupo',
     'Muestra influencia positiva en los demás',
     'Evidencia confianza y seguridad en sus habilidades para inspirar a otros'],
    ['Realiza acciones en pro de su cuidado personal',
     'Es conciente del riesgo de las adicciones o incurrir en conductas ilicitas',
     'Demuestra habitos saludables que promueven su bienestar físico, emocional y social'],
    ['Establece metas a corto, mediano y largo plazo',
     'Evidencia seguridad en sus habilidades para alcanzar sus metas',
     'Construye un proyecto de vida que genera bienestar propio y en la comunidad']
  ]

  students = Student.all

  surveys.each_with_index do |survey_name, si|
    puts "SURVEY: #{survey_name}"
    survey = Survey.find_or_create_by(name: "Fútbol revision comportamiento (#{survey_name})",
                                      key: 'frc_', form_id: 'form_id',
                                      organization_id: Organization.first.id)

    responses = [
      ['La mayoría de las veces no'] * rand(1..3),
      ['Algunas veces si, algunas veces no'] * rand(1..3),
      ['La mayoría de veces si'] * rand(1..3)
    ].flatten

    students.each_with_index do |student, index|
      puts "INDEX: #{index}"
      data = {
        event_id: "behavior_response_id_#{student.id}_#{rand(1..999_999_999)}",
        event_type: 'form_response',
        form_response: {
          form_id: 'f6FKeXWk',
          token: '01HJH6W7HP0CRXACW3Y2QEXT4E',
          landed_at: '2023-12-25T19:22:55Z',
          submitted_at: '2023-12-25T19:22:55Z',
          hidden: {
            branch_id: nil,
            env: 'development',
            student_id: student.id,
            survey_id: survey.id
          },
          definition: {
            id: 'f6FKeXWk',
            title: 'Fútbol revision comportamiento (Proyecto de Vida)',
            fields: [
              {
                id: 'kG7vOqrxaPQR',
                ref: '01HGJ3TTAMEXWK1CNDMBXF2YXJ',
                type: 'date',
                title: 'Fecha',
                properties: {}
              },
              {
                id: 'fVNmXEhNht2i',
                ref: '09c60ad0-8c9d-4afb-a812-b455f80d01a4',
                type: 'short_text',
                title: 'ID del evaluador',
                properties: {}
              },
              {
                id: 'MX1QBagXHYbt',
                ref: '76150f73-8b7c-49a6-a0fc-6368c08f171c',
                type: 'short_text',
                title: 'Nombre del evaluador',
                properties: {}
              },
              {
                id: 'bVe2Kkmk1suV',
                ref: '4818267d-49e7-4e85-b119-56c7182ba2fe',
                type: 'multiple_choice',
                title: '¿el niño asistió durante el mes?',
                properties: {},
                choices: [
                  {
                    id: 'QtzgcSP162Qr',
                    ref: '12908b3e-8c05-497a-b9f9-eb17d83cf35f',
                    label: 'Si'
                  },
                  {
                    id: 'vSaAXvjNVZqF',
                    ref: 'c6c83cfe-f456-4087-9bdf-0cb5f68502da',
                    label: 'No'
                  }
                ]
              },
              {
                id: 'F12GuTy01kux',
                ref: 'e38f200a-771c-4c9c-9803-a2a9f12f5193',
                type: 'multiple_choice',
                title: questions[si][0],
                properties: {},
                choices: [
                  {
                    id: 'sscHdF1QHEGN',
                    ref: 'f03e0138-4264-43a5-a471-6cad90041aed',
                    label: 'La mayoría de las veces no'
                  },
                  {
                    id: 'XUilMQftYWXX',
                    ref: 'ded53c36-9822-4529-ac9e-cc3c7c0a35bc',
                    label: 'Algunas veces si, algunas veces no'
                  },
                  {
                    id: 'AoiSGh9HtypO',
                    ref: '1581d869-94af-4210-b192-d061d66d3c8b',
                    label: 'La mayoría de veces si'
                  }
                ]
              },
              {
                id: '6BSuFE5HuNdA',
                ref: 'd28632e1-e2e3-4c4c-8504-f0bf4aaf7ea0',
                type: 'multiple_choice',
                title: questions[si][1],
                properties: {},
                choices: [
                  {
                    id: '2ctqcIYyNs2P',
                    ref: '1d42bcf9-719f-4153-8784-2cb77526e024',
                    label: 'La mayoría de las veces no'
                  },
                  {
                    id: 'A9qcqjeKhjsM',
                    ref: '11de38d1-8150-4055-8de7-2acf0d3039a0',
                    label: 'Algunas veces si, algunas veces no'
                  },
                  {
                    id: '7NZn0c5i6McX',
                    ref: '9c38b174-03f7-4b76-8dc8-a560b05abd1c',
                    label: 'La mayoría de veces si'
                  }
                ]
              },
              {
                id: 'UAHn8LYdMgpQ',
                ref: 'e3fc7713-8edc-44b0-b7dc-cc4842385aea',
                type: 'multiple_choice',
                title: questions[si][2],
                properties: {},
                choices: [
                  {
                    id: 'a8y18PGC49p9',
                    ref: 'd6c1d051-55c3-48a0-a488-a2daa3483b97',
                    label: 'La mayoría de las veces no'
                  },
                  {
                    id: 'BsJhh8Q7n0bF',
                    ref: 'b2aecb32-73ca-448e-b1e7-239e4cf7fe4f',
                    label: 'Algunas veces si, algunas veces no'
                  },
                  {
                    id: 'CWL6L477pRLY',
                    ref: 'b588ab42-66e8-433a-b0fb-b055b88eb2bc',
                    label: 'La mayoría de veces si'
                  }
                ]
              },
              {
                id: 'uT8hSXWQLmUA',
                ref: '3648cef3-6986-41b3-9861-ea4dde0ffb26',
                type: 'long_text',
                title: 'Observaciones',
                properties: {}
              }
            ]
          },
          answers: [
            {
              type: 'date',
              date: '2023-01-01'
            },
            {
              type: 'text',
              text: 'Lorem ipsum dolor'
            },
            {
              type: 'text',
              text: 'Lorem ipsum dolor'
            },
            {
              type: 'choice',
              choice: {
                label: %w[Si No].sample
              }
            },
            {
              type: 'choice',
              choice: {
                label: responses.sample
              }
            },
            {
              type: 'choice',
              choice: {
                label: responses.sample
              }
            },
            {
              type: 'choice',
              choice: {
                label: responses.sample
              }
            },
            {
              type: 'text',
              text: 'Lorem ipsum dolor'
            }
          ]
        }
      }.with_indifferent_access

      response_id, date, kind_of_measurement, scores, survey_id, branch_id, student_id, single_response_inputs =
        TypeformWebhookDeserializerService.call(data)

      survey_response = SurveyResponse.find_or_initialize_by(
        kind_of_measurement: kind_of_measurement,
        branch_id: branch_id,
        survey_id: survey_id,
        student_id: student_id
      )

      survey_response.date = date
      survey_response.response_id = response_id
      survey_response.json_response = data
      survey_response.scores = scores
      survey_response.single_response_inputs = single_response_inputs

      survey_response.save!
    end
  end
end

task create_tech_test_survey_responses: :environment do
  students = Student.all

  survey = Survey.find_or_create_by(name: 'Test Técnico',
                                    key: 'frc_', form_id: 'form_id',
                                    organization_id: Organization.first.id)

  responses = [
    ['Deficiente'] * rand(1..3),
    ['Regular'] * rand(1..3),
    ['Bueno'] * rand(1..3)
  ].flatten

  students.each_with_index do |student, index|
    puts "INDEX: #{index}"
    data = {
      event_id: "tech_test_response_id_#{student.id}_#{rand(1..999_999_999)}",
      event_type: 'form_response',
      form_response: {
        hidden: {
          branch_id: nil,
          env: 'development',
          student_id: student.id,
          survey_id: survey.id
        },
        definition: {
          id: 'xqYAUDA5',
          title: 'Test Técnico',
          fields: [
            {
              id: 'N0z9cIZzHfpb',
              ref: '01HGJ3TTAMEXWK1CNDMBXF2YXJ',
              type: 'date',
              title: 'Fecha',
              properties: {}
            },
            {
              id: '7prQMb25tSQT',
              ref: '4818267d-49e7-4e85-b119-56c7182ba2fe',
              type: 'multiple_choice',
              title: 'Tipo de medición',
              properties: {},
              choices: [
                {
                  id: 'QkzsN8l12e56',
                  ref: '12908b3e-8c05-497a-b9f9-eb17d83cf35f',
                  label: 'Ingreso'
                },
                {
                  id: 'eVaZimL9lk8e',
                  ref: 'c6c83cfe-f456-4087-9bdf-0cb5f68502da',
                  label: 'Salida'
                }
              ]
            },
            {
              id: 'MIsWJQgWCf5s',
              ref: '09c60ad0-8c9d-4afb-a812-b455f80d01a4',
              type: 'number',
              title: 'Peso',
              properties: {}
            },
            {
              id: '6FbtmPdTabba',
              ref: '76150f73-8b7c-49a6-a0fc-6368c08f171c',
              type: 'number',
              title: 'Estatura',
              properties: {}
            },
            {
              id: 'U9GOUKCSjrKB',
              ref: 'e38f200a-771c-4c9c-9803-a2a9f12f5193',
              type: 'multiple_choice',
              title: 'Dominio (Cabeza)',
              properties: {},
              choices: [
                {
                  id: 'LMs69qOY6fqn',
                  ref: 'f03e0138-4264-43a5-a471-6cad90041aed',
                  label: 'Deficiente'
                },
                {
                  id: '7uaRx5Te31xn',
                  ref: 'ded53c36-9822-4529-ac9e-cc3c7c0a35bc',
                  label: 'Regular'
                },
                {
                  id: '4iTXSlQmvM0x',
                  ref: '1581d869-94af-4210-b192-d061d66d3c8b',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: '50eUD1EzCh6l',
              ref: '24a28fd1-bca9-45ac-ad08-83aefe194523',
              type: 'multiple_choice',
              title: 'Dominio (Muslo)',
              properties: {},
              choices: [
                {
                  id: 'EZLblW6IEJee',
                  ref: '64a3b165-c0fc-4f22-882a-a9baba96ef4b',
                  label: 'Deficiente'
                },
                {
                  id: 'Ge6467dt55Vh',
                  ref: '3e7befad-ef97-477b-ab5a-6608dda0fb76',
                  label: 'Regular'
                },
                {
                  id: 'lnfEEV28Ew0d',
                  ref: 'f6f2dbff-ae02-4b97-aa7b-0871d55125d5',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: '6qNBGLhjCvcR',
              ref: '8efb279a-0af1-4595-a99e-9f28775a48a6',
              type: 'multiple_choice',
              title: 'Dominio (Pie)',
              properties: {},
              choices: [
                {
                  id: 'mNPAHHrsW6Ap',
                  ref: '3b7bb4a6-5049-42de-97b6-01441c3cdb12',
                  label: 'Deficiente'
                },
                {
                  id: 'Pwyhmr8qNfDW',
                  ref: 'ad9af631-5812-40f2-badc-02d7f9d5f48f',
                  label: 'Regular'
                },
                {
                  id: 'aAiVxCgojmuR',
                  ref: '97a16c09-9f49-485b-a56a-f5fc3d818a74',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'v8Hq4v8xRyCL',
              ref: '168fe6ad-a2d9-43cf-85c6-619c2b63e10a',
              type: 'multiple_choice',
              title: 'Conducción (Pie Derecho)',
              properties: {},
              choices: [
                {
                  id: 'l04jew5Oab4w',
                  ref: '8d608eb8-10db-4fcf-80ac-6c08afd26898',
                  label: 'Deficiente'
                },
                {
                  id: 'T8eS2DdXgJHp',
                  ref: '5e901884-5c5d-4d03-995b-234a590ba817',
                  label: 'Regular'
                },
                {
                  id: 'NXwZvjnsHAgD',
                  ref: '2add68af-f5c7-49bf-95c7-15fb881cf68a',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'phiwgcgkGwCy',
              ref: '38b305aa-2c23-4c44-bd06-5e9bb85047b3',
              type: 'multiple_choice',
              title: 'Conducción (Pie Izquierdo)',
              properties: {},
              choices: [
                {
                  id: 'P1En39xFqlU3',
                  ref: '6f7c8fa3-8f29-478f-a7bb-3a7f61f874cd',
                  label: 'Deficiente'
                },
                {
                  id: 'YT5IWCen3zd8',
                  ref: 'dcf3598a-f820-41fc-a2b7-a03639feb620',
                  label: 'Regular'
                },
                {
                  id: 'ct7P03cFv5yz',
                  ref: 'c213d3e9-ba95-4d12-9d68-03fee8e04fed',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'lU7RNrOJuV4L',
              ref: '34c62f77-4034-4afa-9419-1164421063e3',
              type: 'multiple_choice',
              title: 'Recepción (Cabeza)',
              properties: {},
              choices: [
                {
                  id: 'xivkhouLlYXt',
                  ref: '2e2a1a44-87f7-497e-9a15-34ff85e151c1',
                  label: 'Deficiente'
                },
                {
                  id: 'JJBhOjQazd3F',
                  ref: 'c7fc32d7-152c-4f55-9e15-18eca309fdf7',
                  label: 'Regular'
                },
                {
                  id: 'dXUOTspVmTuW',
                  ref: '2323b4f7-e45b-4c1d-a798-8deb67979d8d',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'KxjSSo9GB5ja',
              ref: '071fa6d6-ca73-4837-8ae4-f8979deca135',
              type: 'multiple_choice',
              title: 'Recepción (Pecho)',
              properties: {},
              choices: [
                {
                  id: 'mJ2ymwPJz1Lk',
                  ref: '58ff3500-464e-4829-a7cd-cfb0b8d3012e',
                  label: 'Deficiente'
                },
                {
                  id: 'IjQSfs7rCVGX',
                  ref: '1a757177-5e74-44c5-a39c-52d0a2c44440',
                  label: 'Regular'
                },
                {
                  id: 'UEuUS5DLR4jg',
                  ref: '2700fbfb-d298-4bc8-8969-00f7de50ddf1',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'NOkHxsdlsEKW',
              ref: '901fd93e-17f9-49be-a24a-ac79c899c9e6',
              type: 'multiple_choice',
              title: 'Recepción (Muslo)',
              properties: {},
              choices: [
                {
                  id: 'f7BdrBrJpq52',
                  ref: '5df3e9da-885d-483c-8a06-febd804971dc',
                  label: 'Deficiente'
                },
                {
                  id: 'cqnyHsANBPT4',
                  ref: '8d395b75-f8c4-448c-8361-14182bc73981',
                  label: 'Regular'
                },
                {
                  id: '6bWmnGEoCSVg',
                  ref: '54424d44-8168-488e-9ec0-d441d36edfd1',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'Uzpf7uAgyrww',
              ref: '5fd783c9-b1c7-469a-9d1e-cc8230c3ea01',
              type: 'multiple_choice',
              title: 'Recepción (Borde Interno)',
              properties: {},
              choices: [
                {
                  id: 'TnjbopPFHecg',
                  ref: '9cd23f72-985c-4ef9-91c5-22401424a02d',
                  label: 'Deficiente'
                },
                {
                  id: '2qUKQWI9YYUe',
                  ref: 'a2fb5cbb-6df0-44b6-86d4-a5a7092d7f7f',
                  label: 'Regular'
                },
                {
                  id: 'tw2E2p1mWCiK',
                  ref: 'aa989d0f-cf99-4e51-b6aa-15aad14c5c88',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'gFapCAMYjiB7',
              ref: 'b20cc73a-a227-423e-bf63-efce4dadd86b',
              type: 'multiple_choice',
              title: 'Recepción (Empeine Total)',
              properties: {},
              choices: [
                {
                  id: 'sqTp2MVvNJeX',
                  ref: 'fdd60907-983d-4527-b5c7-548a75c65cf5',
                  label: 'Deficiente'
                },
                {
                  id: '5v7kruEey4VH',
                  ref: 'b2e8cb1b-7c31-4317-a2ad-300ca1c90d4d',
                  label: 'Regular'
                },
                {
                  id: 'ygpopFzWCtwr',
                  ref: '844676eb-c5a8-46a6-bc36-4067c774ea33',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'wiBBqU0a0fza',
              ref: '0ca16b51-c190-4104-8e32-47fe12b3ea67',
              type: 'multiple_choice',
              title: 'Recepción (Planta)',
              properties: {},
              choices: [
                {
                  id: 'yVGTjGweT61C',
                  ref: '64fe31fa-0538-45d2-bd0f-5cf009ce7211',
                  label: 'Deficiente'
                },
                {
                  id: 'IsAhW69HHkKs',
                  ref: '35295f45-6233-49a0-8e60-f24437ee6f78',
                  label: 'Regular'
                },
                {
                  id: 'eeKQ9h37vZ4G',
                  ref: '945ab82c-139c-4105-9cb5-a9acc4c7b84d',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'GCjZTJqlosLE',
              ref: '0cfa6b7b-3061-43ba-be44-34c3f198a966',
              type: 'multiple_choice',
              title: 'Remates (Izquierdo)',
              properties: {},
              choices: [
                {
                  id: 'wYDPHCcxyy4M',
                  ref: '7733f82a-9b1a-4405-b7b7-f3eb52d60739',
                  label: 'Deficiente'
                },
                {
                  id: '2PX4Uvd1rmnS',
                  ref: 'b4cce496-77d2-49db-b7b4-6ed510a774c1',
                  label: 'Regular'
                },
                {
                  id: 'ldKPttYKLyUn',
                  ref: '46e302d6-ea79-46ca-87a0-1f2a0565c155',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: 'TIuqSrliUzLk',
              ref: 'e8e561f1-83bd-490c-9041-66045b5f6e2f',
              type: 'multiple_choice',
              title: 'Remates (Derecho)',
              properties: {},
              choices: [
                {
                  id: '1uO9OXXoMVdB',
                  ref: 'edc45426-e3ce-46af-bbcc-842d4c6dfc60',
                  label: 'Deficiente'
                },
                {
                  id: '2atNluXhEbnL',
                  ref: '9244233d-2511-42a5-8ade-883c412432c1',
                  label: 'Regular'
                },
                {
                  id: 'RCh2wMPohUJW',
                  ref: 'b95d560d-c00f-473c-acd3-d8b498f74b28',
                  label: 'Bueno'
                }
              ]
            },
            {
              id: '9B3cXmQV5U6P',
              ref: '2fd5ed4c-cacc-42fc-8c21-333832ac12da',
              type: 'multiple_choice',
              title: 'Pases (Precisión)',
              properties: {},
              choices: [
                {
                  id: 'dfJ2HalFjvPf',
                  ref: '3d1de99e-623c-46e1-97e8-40bb3e5cd617',
                  label: 'Deficiente'
                },
                {
                  id: 'KQ2jWsK037jV',
                  ref: '25a6237c-d79e-4d00-86c3-7d0d05649796',
                  label: 'Regular'
                },
                {
                  id: 'jDXZ2Eief4I9',
                  ref: '0921f8fd-41b0-4611-ab84-b10e7a5bff23',
                  label: 'Bueno'
                }
              ]
            }
          ],
          endings: [
            {
              id: 'EPojo3ZpOOLo',
              ref: '01HGJ3TTANKZD26HAWDGQ82G6T',
              title: '',
              type: 'thankyou_screen',
              properties: {
                button_text: 'Create a typeform',
                show_button: true,
                share_icons: true,
                button_mode: 'default_redirect'
              }
            }
          ]
        },
        answers: [
          {
            type: 'date',
            date: '2023-01-01',
            field: {
              id: 'N0z9cIZzHfpb',
              type: 'date',
              ref: '01HGJ3TTAMEXWK1CNDMBXF2YXJ'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'QkzsN8l12e56',
              label: ['Ingreso', 'Salida'].sample,
              ref: '12908b3e-8c05-497a-b9f9-eb17d83cf35f'
            }
          },
          {
            type: 'number',
            number: 42,
            field: {
              id: 'MIsWJQgWCf5s',
              type: 'number',
              ref: '09c60ad0-8c9d-4afb-a812-b455f80d01a4'
            }
          },
          {
            type: 'number',
            number: 42,
            field: {
              id: '6FbtmPdTabba',
              type: 'number',
              ref: '76150f73-8b7c-49a6-a0fc-6368c08f171c'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'LMs69qOY6fqn',
              label: responses.sample,
              ref: 'f03e0138-4264-43a5-a471-6cad90041aed'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'EZLblW6IEJee',
              label: responses.sample,
              ref: '64a3b165-c0fc-4f22-882a-a9baba96ef4b'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'mNPAHHrsW6Ap',
              label: responses.sample,
              ref: '3b7bb4a6-5049-42de-97b6-01441c3cdb12'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'l04jew5Oab4w',
              label: responses.sample,
              ref: '8d608eb8-10db-4fcf-80ac-6c08afd26898'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'P1En39xFqlU3',
              label: responses.sample,
              ref: '6f7c8fa3-8f29-478f-a7bb-3a7f61f874cd'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'xivkhouLlYXt',
              label: responses.sample,
              ref: '2e2a1a44-87f7-497e-9a15-34ff85e151c1'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'mJ2ymwPJz1Lk',
              label: responses.sample,
              ref: '58ff3500-464e-4829-a7cd-cfb0b8d3012e'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'f7BdrBrJpq52',
              label: responses.sample,
              ref: '5df3e9da-885d-483c-8a06-febd804971dc'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'TnjbopPFHecg',
              label: responses.sample,
              ref: '9cd23f72-985c-4ef9-91c5-22401424a02d'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'sqTp2MVvNJeX',
              label: responses.sample,
              ref: 'fdd60907-983d-4527-b5c7-548a75c65cf5'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'yVGTjGweT61C',
              label: responses.sample,
              ref: '64fe31fa-0538-45d2-bd0f-5cf009ce7211'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'wYDPHCcxyy4M',
              label: responses.sample,
              ref: '7733f82a-9b1a-4405-b7b7-f3eb52d60739'
            }
          },
          {
            type: 'choice',
            choice: {
              id: '1uO9OXXoMVdB',
              label: responses.sample,
              ref: 'edc45426-e3ce-46af-bbcc-842d4c6dfc60'
            }
          },
          {
            type: 'choice',
            choice: {
              id: 'dfJ2HalFjvPf',
              label: responses.sample,
              ref: '3d1de99e-623c-46e1-97e8-40bb3e5cd617'
            }
          }
        ]
      }
    }.with_indifferent_access

    response_id, date, kind_of_measurement, scores, survey_id, branch_id, student_id, single_response_inputs =
        TypeformWebhookDeserializerService.call(data)

    survey_response = SurveyResponse.find_or_initialize_by(
      kind_of_measurement: kind_of_measurement,
      branch_id: branch_id,
      survey_id: survey_id,
      student_id: student_id
    )

    survey_response.date = date
    survey_response.response_id = response_id
    survey_response.json_response = data
    survey_response.scores = scores
    survey_response.single_response_inputs = single_response_inputs

    survey_response.save!
  end
end
