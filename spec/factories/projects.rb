# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  stack            :text
#  start            :datetime
#  ending           :datetime
#  hours_agreed     :integer
#  tracking_id      :string
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  tracking_service :integer
#  status           :integer
#  hours_spent      :decimal(11, 4)   default("0")
#  currency         :string           default("EUR")
#  budget_cents     :integer          default("0"), not null
#  budget_currency  :string           default("EUR"), not null
#  ratio_cents      :integer          default("0"), not null
#  ratio_currency   :string           default("EUR"), not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#

FactoryGirl.define do
  factory :project do
    name Faker::Lorem.word
    customer
  end
end
