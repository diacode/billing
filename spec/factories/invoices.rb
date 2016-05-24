# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  code        :string
#  expiration  :date
#  vat         :integer
#  created_at  :datetime
#  updated_at  :datetime
#  paid        :boolean          default("false")
#  customer_id :integer
#  currency    :string
#
# Indexes
#
#  index_invoices_on_customer_id  (customer_id)
#

FactoryGirl.define do
  factory :invoice do
    customer
    currency 'EUR'
  end
end
