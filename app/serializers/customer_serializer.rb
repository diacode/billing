class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :billing_info
end
