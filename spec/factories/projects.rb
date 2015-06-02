FactoryGirl.define do
  factory :project do
    name Faker::Lorem.word
    customer
  end
end