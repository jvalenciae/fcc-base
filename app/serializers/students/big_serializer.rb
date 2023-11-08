# frozen_string_literal: true

module Students
  class BigSerializer < ActiveModel::Serializer
    attributes :id, :id_type, :id_number, :name, :birthplace, :birthdate, :gender, :status, :height, :weight,
               :tshirt_size, :shorts_size, :socks_size, :shoe_size, :favourite_colour, :favourite_food,
               :favourite_sport, :favourite_place, :study_day, :grade, :feeling_when_playing_soccer, :country,
               :department, :city, :neighborhood, :address, :school, :health_coverage, :eps,
               :extracurricular_activities, :displaced, :displacement_origin, :displacement_reason, :program,
               :lives_with_reinserted_familiar, :lives_with_parent, :beneficiary_of_another_foundation,
               :withdrawal_date, :withdrawal_reason

    belongs_to :branch
    belongs_to :group

    def country
      {
        code: object.country,
        name: CS.countries[object.country.to_sym]
      }
    end
  end
end
