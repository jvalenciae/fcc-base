# frozen_string_literal: true

states = %i[AMA ANT ARA ATL BOL BOY CAL CAQ CAS CAU CES CHO COR CUN DC GUA GUV HUI
            LAG MAG MET NAR NSA PUT QUI RIS SAN SAP SUC TOL VAC VAU VID]

values = ['Amazonas', 'Antioquia', 'Arauca', 'Atlántico', 'Bolívar', 'Boyacá', 'Caldas', 'Caquetá', 'Casanare',
          'Cauca', 'Cesar', 'Chocó', 'Córdoba', 'Cundinamarca', 'Bogotá D.C.', 'Guainía', 'Guaviare', 'Huila',
          'La Guajira', 'Magdalena', 'Meta', 'Nariño', 'Norte de Santander', 'Putumayo', 'Quindío', 'Risaralda',
          'Santander', 'San Andrés y Providencia', 'Sucre', 'Tolima', 'Valle del Cauca', 'Vaupés', 'Vichada']

states.each_with_index do |state, index|
  CS.states(:CO)[state] = values[index]
end
