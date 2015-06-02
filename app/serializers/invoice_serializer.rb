class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :code, :expiration, :vat, :paid, :created_at, :updated_at, :customer_id
end
