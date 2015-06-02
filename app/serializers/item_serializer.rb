class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :cost, :period_start, :period_end, :hours, 
    :invoice_id, :project_id, :created_at, :updated_at

  has_one :project
end
