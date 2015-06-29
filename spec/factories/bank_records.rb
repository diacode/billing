# == Schema Information
#
# Table name: bank_records
#
#  id             :integer          not null, primary key
#  subject        :string
#  amount         :decimal(11, 2)
#  balance        :decimal(11, 2)
#  operation_at   :date
#  value_at       :date
#  created_at     :datetime
#  updated_at     :datetime
#  transaction_id :string
#

FactoryGirl.define do
  factory :bank_record do
    subject Faker::Name.title
    amount 3000
    balance 3000
    operation_at Date.today
    value_at Date.today
  end
end
