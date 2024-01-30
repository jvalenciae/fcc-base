# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  include UserConcerns

  attributes :id, :title, :description, :due_date, :status, :overdue

  def overdue
    object.overdue?
  end
end
