# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  name         :string
#  billing_info :text
#  created_at   :datetime
#  updated_at   :datetime
#  email        :string
#  picture      :string
#  language     :string           default("en")
#

FactoryGirl.define do
  factory :customer do
    name Faker::Name.name
  end
end
