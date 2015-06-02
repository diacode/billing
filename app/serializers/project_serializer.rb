class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :stack, :start, :ending, :budget, :ratio, :hours_agreed, :status, :tracking_id, :tracking_service, :customer_id
end
