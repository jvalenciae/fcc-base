# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :quicksight_embed_src, :quicksight_dashboard_id

  belongs_to :organization
end
