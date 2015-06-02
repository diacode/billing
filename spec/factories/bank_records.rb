FactoryGirl.define do
  factory :bank_record do
    subject Faker::Name.title
    amount 3000
    balance 3000
    operation_at Date.today
    value_at Date.today
  end
end