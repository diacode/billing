class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :period_start, :period_end, :hours, 
    :invoice_id, :project_id, :created_at, :updated_at, :cost

  has_one :project

  def cost
    object.cost.to_f
  end
end
