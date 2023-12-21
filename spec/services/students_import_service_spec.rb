# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsImportService do
  let(:file_url) { 'http://example.com/children.csv' }

  before do
    branch = create(:branch, id: '436b229d-e7b0-4156-862a-93b573348026')
    create(:group, id: '80ec2e9f-8b3d-473b-a261-4a278505124a', branch: branch)
  end

  describe '#call' do
    it 'imports students from a CSV file' do
      csv_data = <<~CSV
        id_type,id_number,name,birthdate,birthplace,gender,status,withdrawal_reason,withdrawal_date,country,city,department,neighborhood,address,school,study_day,grade,extracurricular_activities,health_coverage,eps,lives_with_parent,displaced,displacement_reason,displacement_origin,lives_with_reinserted_familiar,program,beneficiary_of_another_foundation,height,weight,tshirt_size,shorts_size,socks_size,shoe_size,favourite_colour,favourite_food,favourite_sport,favourite_place,feeling_when_playing_soccer,branch_id,group_id
        Registro civil,111,name1,2008-08-08,Caucasia,female,active,,,CO,Clemencia,Bolívar,Bello Horizonte,Finca La Esperanza,San Jose De Clemencia,Mañana,1,ec1,sisben,Coosalud,TRUE,FALSE,,,FALSE,,FALSE,120,40,6,4,4,0,Morado,Carne Frita,Futbol,Soledad,Felicidad,436b229d-e7b0-4156-862a-93b573348026,80ec2e9f-8b3d-473b-a261-4a278505124a
        Registro civil,222,name2,2008-08-08,Caucasia,female,active,,,CO,Clemencia,Bolívar,Bello Horizonte,Finca La Esperanza,San Jose De Clemencia,Mañana,1,ec1,sisben,Coosalud,TRUE,FALSE,,,FALSE,,FALSE,120,40,6,4,4,0,Morado,Carne Frita,Futbol,Soledad,Felicidad,436b229d-e7b0-4156-862a-93b573348026,80ec2e9f-8b3d-473b-a261-4a278505124a
      CSV

      stub_request(:get, file_url).to_return(body: csv_data, status: 200)

      expect do
        described_class.call(file_url)
      end.to change(Student, :count).by(2)

      expect(Student.find_by(id_number: '111')).to be_present
      expect(Student.find_by(id_number: '222')).to be_present
      expect(ImportMailer).to have_received(:students)
    end
  end
end
